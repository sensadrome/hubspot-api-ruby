# Releasing to Rubygems

1. Update History.md
2. Update gemspec.
3. Push updates to github.
4. Build gem with `gem build hubspot-api-ruby.gemspec`.
5. Push the resulting .gem file to Rubygems with `gem push`
