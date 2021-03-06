defmodule AuthShield.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: AuthShield.Repo

  alias AuthShield.Authentication.Schemas.{LoginAttempt, Session}
  alias AuthShield.Credentials.Schemas.{Password, PIN, PublicKey, TOTP}
  alias AuthShield.Resources.Schemas.{Application, Permission, Role, Scope, User}

  # Authentication

  def session_factory do
    %Session{
      user_id: Ecto.UUID.generate(),
      remote_ip: sequence(:session_remote_ip, &"172.31.4.#{&1}"),
      user_agent: "Mozilla/5.0 (Windows NT x.y; rv:10.0) Gecko/20100101 Firefox/10.0",
      login_at: NaiveDateTime.utc_now(),
      expiration: NaiveDateTime.utc_now() |> NaiveDateTime.add(60 * 15, :second)
    }
  end

  def login_attempt_factory do
    %LoginAttempt{
      user_id: Ecto.UUID.generate(),
      remote_ip: sequence(:session_remote_ip, &"172.31.4.#{&1}"),
      user_agent: "Mozilla/5.0 (Windows NT x.y; rv:10.0) Gecko/20100101 Firefox/10.0",
      status: "succeed",
      inserted_at: NaiveDateTime.utc_now()
    }
  end

  # Resources

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
      email: sequence(:user_email, &"#{&1}@AuthShield.com")
    }
  end

  def application_factory do
    %Application{
      name: sequence(:application_name, &"My application #{&1}"),
      description: sequence(:application_description, &"Application #{&1}")
    }
  end

  def scope_factory do
    %Scope{
      name: sequence(:role_name, &"user:#{&1}"),
      description: sequence(:role_description, &"User scope #{&1}")
    }
  end

  # Credentials

  def password_factory do
    %Password{
      user_id: Ecto.UUID.generate(),
      password: "My_passw@rd1",
      password_hash: Argon2.hash_pwd_salt("My_passw@rd1")
    }
  end

  def pin_factory do
    %PIN{
      user_id: Ecto.UUID.generate(),
      pin: "123456",
      pin_hash: Argon2.hash_pwd_salt("123456")
    }
  end

  def totp_factory do
    secret = TOTP.generate_random_secret()
    issuer = "AuthShield"
    email = "email@AuthShield.com"
    label = :http_uri.encode("#{issuer}:#{email}")
    digits = 6
    period = 30

    qrcode_base64 = gen_qrcode_base64(label, secret, issuer, digits, period)

    %TOTP{
      user_id: Ecto.UUID.generate(),
      secret: secret,
      email: email,
      issuer: issuer,
      digits: digits,
      period: period,
      qrcode_base64: qrcode_base64
    }
  end

  def public_key_factory do
    %PublicKey{
      application_id: Ecto.UUID.generate(),
      key: gen_public_key(),
      format: "pem"
    }
  end

  # Helpers

  def gen_qrcode_base64(label, secret, issuer, digits, period) do
    "otpauth://totp/#{label}?secret=#{secret}&issuer=#{issuer}&digits=#{digits}&period=#{period}&algorithm=SHA1"
    |> EQRCode.encode()
    |> EQRCode.png()
    |> Base.encode64(padding: false)
  end

  def gen_public_key do
    :auth_shield
    |> :code.priv_dir()
    |> Path.join("/keys/public-key.pub")
    |> File.read!()
  end

  def gen_private_key do
    :auth_shield
    |> :code.priv_dir()
    |> Path.join("/keys/private-key.pub")
    |> File.read!()
  end
end
