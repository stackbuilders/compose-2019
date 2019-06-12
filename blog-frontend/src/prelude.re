let either: ('err => 'a) => ('ok => 'a) => Belt.Result.t('ok, 'err) => 'a =
(ferr, fok, result) => switch(result) {
  | Belt.Result.Error(err) => ferr(err)
  | Belt.Result.Ok(ok) => fok(ok)
  };
