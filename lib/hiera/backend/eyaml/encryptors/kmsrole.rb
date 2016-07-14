require 'openssl'
require 'hiera/backend/eyaml/encryptor'
require 'hiera/backend/eyaml/utils'
require 'hiera/backend/eyaml/options'
require 'aws-sdk'

class Hiera
  module Backend
    module Eyaml
      module Encryptors

        class KmsRole < Encryptor

          self.options = {
            :key_id => {      :desc => "KMS Key ID",
                              :type => :string,
                              :default => "" },
            :iam_role => {    :desc => "IAM Role to assume",
                              :type => :string,
                              :default => "" },
            :client_profile => {  :desc => "AWS Client Profile",
                                  :type => :string,
                                  :default => "" },
            :aws_region => {  :desc => "AWS Region",
                              :type => :string,
                              :default => "ap-southeast-2" }
          }

          MAJOR = "0"
          MINOR = "2"
          BUILD = ENV["GEM_BUILD"] || "DEV"
          VERSION = [MAJOR, MINOR, BUILD].join(".")

          self.tag = "KMSROLE"

          def self.encrypt plaintext
            aws_region = self.option :aws_region
            key_id = self.option :key_id

            client_profile = self.option :client_profile
            iam_role = self.option :iam_role

            raise StandardError, "key_id is not defined" unless key_id

            if client_profile.nil? || client_profile.empty?
              credentials = Aws::SharedCredentials.new()
            else
              credentials = Aws::SharedCredentials.new(profile_name: client_profile)
            end

            if ! (iam_role.nil? || iam_role.empty?)
              role_credentials = Aws::AssumeRoleCredentials.new(
                client: Aws::STS::Client.new(region: aws_region, credentials: credentials),
                role_arn: iam_role,
                role_session_name: "hiera-secret"
              )
              credentials = role_credentials
            end

            @kms = ::Aws::KMS::Client.new(
              region: aws_region,
              credentials: credentials
            )

            resp = @kms.encrypt({
              key_id: key_id,
              plaintext: plaintext
            })

            resp.ciphertext_blob
          end

          def self.decrypt ciphertext
            aws_region = self.option :aws_region

            client_profile = self.option :client_profile
            iam_role = self.option :iam_role


            if client_profile.nil? || client_profile.empty?
              credentials = Aws::SharedCredentials.new()
            else
              credentials = Aws::SharedCredentials.new(profile_name: client_profile)
            end

            if ! (iam_role.nil? || iam_role.empty?)
              role_credentials = Aws::AssumeRoleCredentials.new(
                client: Aws::STS::Client.new(region: aws_region, credentials: credentials),
                role_arn: iam_role,
                role_session_name: "hiera-secret"
              )
              credentials = role_credentials
            end

            @kms = ::Aws::KMS::Client.new(
              region: aws_region,
              credentials: credentials
            )

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
