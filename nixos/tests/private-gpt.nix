{ pkgs, lib, ... }:
let
  mainPort = "8001";
in
{
  name = "private-gpt";
  meta = with lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    machine =
      { ... }:
      {
        services.private-gpt = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("private-gpt.service")
    machine.wait_for_open_port(${mainPort})

    machine.succeed("curl http://127.0.0.1:${mainPort}")
  '';
}
