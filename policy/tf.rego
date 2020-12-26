package tf

# https://www.terraform.io/docs/configuration/provider-requirements.html
deny[msg] {
  p := input.provider[_]
  p.version
  msg := p[_]
}
