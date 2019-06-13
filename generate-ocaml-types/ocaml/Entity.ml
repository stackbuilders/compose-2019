type ('key, 'value) entity =
  { entityKey : 'key
  ; entityValue : 'value
  }

let encodeEntity encodeKey encodeValue entity =
  Aeson.Encode.object_
    [ ("key", encodeKey entity.entityKey)
    ; ("value", encodeValue entity.entityValue)
    ]

let decodeEntity decodeKey decodeValue json =
  let unwrapped decoder = fun json -> Aeson.Decode.unwrapResult (decoder json)
  in match Aeson.Decode.
    { entityKey = field "key" (unwrapped decodeKey) json
    ; entityValue = field "value" (unwrapped decodeValue) json
    }
  with
  | v -> Belt.Result.Ok v
  | exception Aeson.Decode.DecodeError message -> Belt.Result.Error ("decodeEntity: " ^ message)