type ('key, 'value) entity =
  { entityKey : 'key
  ; entityValue : 'value
  }

val encodeEntity
  :  ('key -> Js.Json.t)
  -> ('value -> Js.Json.t)
  -> ('key, 'value) entity
  -> Js.Json.t

val decodeEntity
  :  (Js.Json.t -> ('key, string) Belt.Result.t)
  -> (Js.Json.t -> ('value, string) Belt.Result.t)
  -> Js.Json.t
  -> (('key, 'value) entity, string) Belt.Result.t
