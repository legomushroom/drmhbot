let List/map =
      https://prelude.dhall-lang.org/v20.2.0/List/map
        sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let Entry =
      https://prelude.dhall-lang.org/v20.2.0/Map/Entry
        sha256:f334283bdd9cd88e6ea510ca914bc221fc2dab5fb424d24514b2e0df600d5346

let flatten =
      https://prelude.dhall-lang.org/v20.2.0/List/concat
        sha256:54e43278be13276e03bd1afa89e562e94a0a006377ebea7db14c7562b0de292b
        (Entry Text Text)

let Domains = < Single : Text | Multiple : List Text >

let Source = { name : Text, domains : Domains }

let fn =
      λ(source : Source) →
        merge
          { Single =
              λ(domain : Text) → [ { mapKey = domain, mapValue = source.name } ]
          , Multiple =
              λ(domains : List Text) →
                List/map
                  Text
                  (Entry Text Text)
                  ( λ(domain : Text) →
                      { mapKey = domain, mapValue = source.name }
                  )
                  domains
          }
          source.domains

in  { source =
        λ(name : Text) →
        λ(domain : Text) →
          { name, domains = Domains.Single domain }
    , multiSource =
        λ(name : Text) →
        λ(domains : List Text) →
          { name, domains = Domains.Multiple domains }
    , toDomainMap =
        λ(sources : List Source) →
          flatten (List/map Source (List (Entry Text Text)) fn sources)
    }
