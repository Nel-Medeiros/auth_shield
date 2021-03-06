defmodule AuthShield.CredentialsTest do
  use AuthShield.DataCase, async: true

  alias AuthShield.{Credentials, DelegatorMock}
  alias AuthShield.Credentials.Schemas.{Password, PIN, PublicKey, TOTP}

  describe "AuthShield.Credentials" do
    setup do
      {:ok, user: insert(:user), application: insert(:application)}
    end

    # PASSWORD CREDENTIALS

    test "delegates from create_password/1 to password #{inspect(Credentials.Passwords)}.insert/1",
         ctx do
      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :create_password}, {Credentials.Passwords, :insert}, [params] ->
          {:ok, insert(:password, params)}
        end
      )

      assert Credentials.create_password(%{params_for(:password) | user_id: ctx.user.id})
    end

    test "delegates from create_password!/1 to password #{inspect(Credentials.Passwords)}.insert!/1",
         ctx do
      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :create_password!}, {Credentials.Passwords, :insert!}, [params] ->
          insert(:password, params)
        end
      )

      assert Credentials.create_password!(%{params_for(:password) | user_id: ctx.user.id})
    end

    test "delegates from update_password/2 to password #{inspect(Credentials.Passwords)}.update/2",
         ctx do
      password = insert(:password, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :update_password},
           {Credentials.Passwords, :update},
           [%Password{} = password, _params] ->
          {:ok, password}
        end
      )

      assert Credentials.update_password(password, %{params_for(:password) | user_id: ctx.user.id})
    end

    test "delegates from update_password!/2 to password #{inspect(Credentials.Passwords)}.update!/2",
         ctx do
      password = insert(:password, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :update_password!},
           {Credentials.Passwords, :update!},
           [%Password{} = password, _params] ->
          password
        end
      )

      assert Credentials.update_password!(password, %{
               params_for(:password)
               | user_id: ctx.user.id
             })
    end

    test "delegates from list_password/1 to password #{inspect(Credentials.Passwords)}.list/1",
         ctx do
      password = insert(:password, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :list_password}, {Credentials.Passwords, :list}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          [password]
        end
      )

      assert Credentials.list_password(user_id: ctx.user.id)
    end

    test "delegates from get_password_by/1 to password #{inspect(Credentials.Passwords)}.get_by/1",
         ctx do
      password = insert(:password, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :get_password_by}, {Credentials.Passwords, :get_by}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          password
        end
      )

      assert Credentials.get_password_by(user_id: ctx.user.id)
    end

    test "delegates from get_password_by!/1 to password #{inspect(Credentials.Passwords)}.get_by!/1",
         ctx do
      password = insert(:password, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :get_password_by!}, {Credentials.Passwords, :get_by!}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          password
        end
      )

      assert Credentials.get_password_by!(user_id: ctx.user.id)
    end

    test "delegates from delete_password/1 to password #{inspect(Credentials.Passwords)}.delete/1",
         ctx do
      password = insert(:password, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :delete_password},
           {Credentials.Passwords, :delete},
           [%Password{} = password] ->
          {:ok, password}
        end
      )

      assert Credentials.delete_password(password)
    end

    test "delegates from delete_password!/1 to password #{inspect(Credentials.Passwords)}.delete!/1",
         ctx do
      password = insert(:password, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :delete_password!},
           {Credentials.Passwords, :delete!},
           [%Password{} = password] ->
          password
        end
      )

      assert Credentials.delete_password!(password)
    end

    test "delegates from check_password?/2 to password #{inspect(Credentials.Passwords)}.check_password?/2",
         ctx do
      password = insert(:password, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :check_password?},
           {Credentials.Passwords, :check_password?},
           [%Password{}, _pass_code] ->
          true
        end
      )

      assert true == Credentials.check_password?(password, "MyPassword")
    end

    # PIN CREDENTIALS

    test "delegates from create_pin/1 to pin #{inspect(Credentials.PIN)}.insert/1", ctx do
      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :create_pin}, {Credentials.PIN, :insert}, [params] ->
          {:ok, insert(:pin, params)}
        end
      )

      assert Credentials.create_pin(%{params_for(:pin) | user_id: ctx.user.id})
    end

    test "delegates from create_pin!/1 to pin #{inspect(Credentials.PIN)}.insert!/1",
         ctx do
      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :create_pin!}, {Credentials.PIN, :insert!}, [params] ->
          insert(:pin, params)
        end
      )

      assert Credentials.create_pin!(%{params_for(:pin) | user_id: ctx.user.id})
    end

    test "delegates from list_pin/1 to pin #{inspect(Credentials.PIN)}.list/1", ctx do
      pin = insert(:pin, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :list_pin}, {Credentials.PIN, :list}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          [pin]
        end
      )

      assert Credentials.list_pin(user_id: ctx.user.id)
    end

    test "delegates from get_pin_by/1 to pin #{inspect(Credentials.PIN)}.get_by/1", ctx do
      pin = insert(:pin, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :get_pin_by}, {Credentials.PIN, :get_by}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          pin
        end
      )

      assert Credentials.get_pin_by(user_id: ctx.user.id)
    end

    test "delegates from get_pin_by!/1 to pin #{inspect(Credentials.PIN)}.get_by!/1",
         ctx do
      pin = insert(:pin, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :get_pin_by!}, {Credentials.PIN, :get_by!}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          pin
        end
      )

      assert Credentials.get_pin_by!(user_id: ctx.user.id)
    end

    test "delegates from delete_pin/1 to pin #{inspect(Credentials.PIN)}.delete/1", ctx do
      pin = insert(:pin, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :delete_pin}, {Credentials.PIN, :delete}, [%PIN{} = pin] ->
          {:ok, pin}
        end
      )

      assert Credentials.delete_pin(pin)
    end

    test "delegates from delete_pin!/1 to pin #{inspect(Credentials.PIN)}.delete!/1",
         ctx do
      pin = insert(:pin, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :delete_pin!}, {Credentials.PIN, :delete!}, [%PIN{} = pin] ->
          pin
        end
      )

      assert Credentials.delete_pin!(pin)
    end

    test "delegates from check_pin?/2 to pin #{inspect(Credentials.PIN)}.check_pin?/2",
         ctx do
      pin = insert(:pin, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :check_pin?}, {Credentials.PIN, :check_pin?}, [%PIN{}, _pin_code] ->
          true
        end
      )

      assert true == Credentials.check_pin?(pin, "222222")
    end

    # TOTP CREDENTIALS

    test "delegates from create_totp/1 to totp #{inspect(Credentials.TOTP)}.insert/1",
         ctx do
      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :create_totp}, {Credentials.TOTP, :insert}, [params] ->
          {:ok, insert(:totp, params)}
        end
      )

      assert Credentials.create_totp(%{params_for(:totp) | user_id: ctx.user.id})
    end

    test "delegates from create_totp!/1 to totp #{inspect(Credentials.TOTP)}.insert!/1",
         ctx do
      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :create_totp!}, {Credentials.TOTP, :insert!}, [params] ->
          insert(:totp, params)
        end
      )

      assert Credentials.create_totp!(%{params_for(:totp) | user_id: ctx.user.id})
    end

    test "delegates from list_totp/1 to totp #{inspect(Credentials.TOTP)}.list/1", ctx do
      totp = insert(:totp, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :list_totp}, {Credentials.TOTP, :list}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          [totp]
        end
      )

      assert Credentials.list_totp(user_id: ctx.user.id)
    end

    test "delegates from get_totp_by/1 to totp #{inspect(Credentials.TOTP)}.get_by/1",
         ctx do
      totp = insert(:totp, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :get_totp_by}, {Credentials.TOTP, :get_by}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          totp
        end
      )

      assert Credentials.get_totp_by(user_id: ctx.user.id)
    end

    test "delegates from get_totp_by!/1 to totp #{inspect(Credentials.TOTP)}.get_by!/1",
         ctx do
      totp = insert(:totp, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :get_totp_by!}, {Credentials.TOTP, :get_by!}, [filters] ->
          assert ctx.user.id == filters[:user_id]
          totp
        end
      )

      assert Credentials.get_totp_by!(user_id: ctx.user.id)
    end

    test "delegates from delete_totp/1 to totp #{inspect(Credentials.TOTP)}.delete/1",
         ctx do
      totp = insert(:totp, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :delete_totp}, {Credentials.TOTP, :delete}, [%TOTP{} = totp] ->
          {:ok, totp}
        end
      )

      assert Credentials.delete_totp(totp)
    end

    test "delegates from delete_totp!/1 to totp #{inspect(Credentials.TOTP)}.delete!/1",
         ctx do
      totp = insert(:totp, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :delete_totp!}, {Credentials.TOTP, :delete!}, [%TOTP{} = totp] ->
          totp
        end
      )

      assert Credentials.delete_totp!(totp)
    end

    test "delegates from check_totp?/3 to totp #{inspect(Credentials.TOTP)}.check_totp?/3",
         ctx do
      totp = insert(:totp, user_id: ctx.user.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :check_totp?},
           {Credentials.TOTP, :check_totp?},
           [%TOTP{}, _totp_code, _now] ->
          true
        end
      )

      assert true == Credentials.check_totp?(totp, "222222", NaiveDateTime.utc_now())
    end

    # PUBLIC KEY CREDENTIALS

    test "delegates from create_public_key/1 to public key #{inspect(Credentials.PublicKey)}.insert/1",
         ctx do
      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :create_public_key}, {Credentials.PublicKey, :insert}, [params] ->
          {:ok, insert(:public_key, params)}
        end
      )

      assert Credentials.create_public_key(%{
               params_for(:public_key)
               | application_id: ctx.application.id
             })
    end

    test "delegates from create_public_key!/1 to public key #{inspect(Credentials.PublicKey)}.insert!/1",
         ctx do
      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :create_public_key!}, {Credentials.PublicKey, :insert!}, [params] ->
          insert(:public_key, params)
        end
      )

      assert Credentials.create_public_key!(%{
               params_for(:public_key)
               | application_id: ctx.application.id
             })
    end

    test "delegates from list_public_key/1 to public key #{inspect(Credentials.PublicKey)}.list/1",
         ctx do
      public_key = insert(:public_key, application_id: ctx.application.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :list_public_key}, {Credentials.PublicKey, :list}, [filters] ->
          assert ctx.application.id == filters[:application_id]
          [public_key]
        end
      )

      assert Credentials.list_public_key(application_id: ctx.application.id)
    end

    test "delegates from get_public_key_by/1 to public key #{inspect(Credentials.PublicKey)}.get_by/1",
         ctx do
      public_key = insert(:public_key, application_id: ctx.application.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :get_public_key_by}, {Credentials.PublicKey, :get_by}, [filters] ->
          assert ctx.application.id == filters[:application_id]
          public_key
        end
      )

      assert Credentials.get_public_key_by(application_id: ctx.application.id)
    end

    test "delegates from get_public_key_by!/1 to public key #{inspect(Credentials.PublicKey)}.get_by!/1",
         ctx do
      public_key = insert(:public_key, application_id: ctx.application.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :get_public_key_by!}, {Credentials.PublicKey, :get_by!}, [filters] ->
          assert ctx.application.id == filters[:application_id]
          public_key
        end
      )

      assert Credentials.get_public_key_by!(application_id: ctx.application.id)
    end

    test "delegates from delete_public_key/1 to public key #{inspect(Credentials.PublicKey)}.delete/1",
         ctx do
      public_key = insert(:public_key, application_id: ctx.application.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :delete_public_key},
           {Credentials.PublicKey, :delete},
           [%PublicKey{} = public_key] ->
          {:ok, public_key}
        end
      )

      assert Credentials.delete_public_key(public_key)
    end

    test "delegates from delete_public_key!/1 to public key #{inspect(Credentials.PublicKey)}.delete!/1",
         ctx do
      public_key = insert(:public_key, application_id: ctx.application.id)

      expect(
        DelegatorMock,
        :apply,
        fn {Credentials, :delete_public_key!},
           {Credentials.PublicKey, :delete!},
           [%PublicKey{} = public_key] ->
          public_key
        end
      )

      assert Credentials.delete_public_key!(public_key)
    end
  end
end
