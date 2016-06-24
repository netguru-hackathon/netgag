ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Netgag.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Netgag.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Netgag.Repo)

