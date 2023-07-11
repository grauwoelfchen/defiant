module Defiant exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)

type Msg
  = Todo

type alias Id =
  Int

type alias Bookmark =
  { id: Id
  }

type alias Model =
  Bookmark

-- TODO
initialModel : Model
initialModel =
  { id = 1
  }

view : Model -> Html Msg
view model =
  div []
    [ div [ class "header" ]
      [ h1 [] [ text "Defiant" ] ]
    , div [ class "content" ]
      [ ]
    ]

update : Msg -> Model -> Model
update msg model =
  case msg of
    _ -> model

main : Program () Model Msg
main =
  Browser.sandbox
    { init = initialModel
    , view = view
    , update = update
    }
