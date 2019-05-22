require 'openssl'
require 'hiera/backend/eyaml/encryptor'
require 'hiera/backend/eyaml/utils'
require 'hiera/backend/eyaml/options'
require 'aws-sdk-kms'

class Hiera
  module Backend
    module Eyaml
      module Encryptors

        class Kms < Encryptor

          self.options = {
            :key_id => {      :desc => "KMS Key ID",
                              :type => :string,
                              :default => "" },
            :iam_role => {    :desc => "IAM Role to assume",
                              :type => :string,
                              :default => "" },
            :aws_region => {  :desc => "AWS Region",
                              :type => :string,
                              :default => "" },
            :aws_profile => { :desc => "AWS Account",
                              :type => :string,
                              :default => ""}
          }

          VERSION = "0.2"
          self.tag = "KMS"

          def self.encrypt plaintext
            # puts 'encrypting...'
            iam_role = self.option :iam_role
            aws_profile = self.option :aws_profile
            aws_region = self.option :aws_region
            key_id = self.option :key_id

            # puts "Iam Role: #{iam_role}"
            # puts "Aws Profile: #{aws_profile}"
            # puts "Aws Region: #{aws_region}"
            # puts "Key Id: #{key_id}"

            raise StandardError, "key_id is not defined" unless key_id

            # if iam_role is specified, use it
            if ! (iam_role.nil? || iam_role.empty?)
              # puts 'encrypting assuming role...'
              role_credentials = Aws::AssumeRoleCredentials.new(
                client: Aws::STS::Client.new(region: aws_region),
                role_arn: iam_role,
                role_session_name: 'hiera'
              )
              @kms = ::Aws::KMS::Client.new(
                credentials: role_credentials,
                region: aws_region
              )
            else
              # puts 'encrypting using aws credentials...'
              # iam role isn't specified, use aws_profile if given, otherwise will fall back to instance profile as per sdk doco
              @kms = ::Aws::KMS::Client.new(
                profile: aws_profile,
                region: aws_region
              )
            end

            resp = @kms.encrypt({
              key_id: key_id,
              plaintext: plaintext
            })

            resp.ciphertext_blob
          end

          def self.decrypt ciphertext
            iam_role = self.option :iam_role
            aws_profile = self.option :aws_profile
            aws_region = self.option :aws_region

            # puts "Iam Role: #{iam_role}"
            # puts "Aws Profile: #{aws_profile}"
            # puts "Aws Region: #{aws_region}"

            # if iam_role is specified, use it
            if ! (iam_role.nil? || iam_role.empty?)
              # puts 'decrypting assuming role...'
              role_credentials = Aws::AssumeRoleCredentials.new(
                client: Aws::STS::Client.new(region: aws_region),
                role_arn: iam_role,
                role_session_name: 'hiera'
              )
              @kms = ::Aws::KMS::Client.new(
                credentials: role_credentials,
                region: aws_region
              )
            else
              # puts 'decrypting using aws credentials...'
              # iam role isn't specified, use aws_profile if given, otherwise will fall back to instance profile as per sdk doco
              @kms = ::Aws::KMS::Client.new(
                profile: aws_profile,
                region: aws_region
              )
            end

            resp = @kms.decrypt({
              ciphertext_blob: ciphertext
            })

            resp.plaintext
          end

        end

      end

    end

  end

end
