defmodule AuthX.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: AuthX.Repo

  alias AuthX.Credentials.Schemas.{Password, PIN, TOTP}
  alias AuthX.Resources.Schemas.{Permission, Role, User}

  def permission_factory do
    %Permission{
      name: sequence(:permission_name, &"create_user_#{&1}"),
      description: sequence(:permission_description, &"Can create user #{&1}")
    }
  end

  def role_factory do
    %Role{
      name: sequence(:role_name, &"admin_#{&1}"),
      description: sequence(:role_description, &"Admin role #{&1}")
    }
  end

  def user_factory do
    %User{
      first_name: sequence(:user_first_name, &"Jane #{&1}"),
      last_name: sequence(:user_last_name, &"Smith #{&1}"),
      email: sequence(:user_email, &"#{&1}@authx.com")
    }
  end

  def password_factory do
    %Password{password: "My_passw@rd1", password_hash: Argon2.hash_pwd_salt("My_passw@rd1")}
  end

  def pin_factory do
    %PIN{pin: "123456", pin_hash: Argon2.hash_pwd_salt("123456")}
  end

  def totp_factory do
    secret = TOTP.generate_random_secret()
    issuer = "AuthX"
    email = "email@authx.com"
    label = :http_uri.encode("#{issuer}:#{email}")
    digits = 6
    period = 30

    qrcode_base64 =
      "otpauth://totp/#{label}?secret=#{secret}&issuer=#{issuer}&digits=#{digits}&period=#{period}&algorithm=SHA1"
      |> EQRCode.encode()
      |> EQRCode.png()
      |> Base.encode64(padding: false)

    %TOTP{
      secret: secret,
      email: email,
      issuer: issuer,
      digits: digits,
      period: period,
      qrcode_base64: qrcode_base64
    }
  end
end