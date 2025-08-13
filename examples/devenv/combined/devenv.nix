{
  pkgs,
  inputs,
  ...
}:
{
  dotenv.enable = true;

  # NOTE The shell outputs of all the reference devenv modules will be shown, regardless.
  enterShell = '''';

  # NOTE The test of all reference devenv modules will be executed, regardless.
  # https://devenv.sh/tests/
  enterTest = '''';
}
