module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Round


---- MODEL ----


type alias Model =
    { umaCerveja : Float
    , quantasCervejas : Float
    , quantosPorcento : Float
    , quantasPessoas : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { umaCerveja = 0
      , quantasCervejas = 0
      , quantosPorcento = 10
      , quantasPessoas = 1
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = MudaPrecoDaCerveja String
    | MudaQuantasCervejas String
    | MudaPorcentagem String
    | MudaQuantasPessoas String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MudaPrecoDaCerveja novoPreco ->
            ( { model | umaCerveja = Result.withDefault 0 (String.toFloat novoPreco) }, Cmd.none )

        MudaQuantasCervejas quantidade ->
            ( { model | quantasCervejas = Result.withDefault 0 (String.toFloat quantidade) }, Cmd.none )

        MudaPorcentagem porcentagem ->
            ( { model | quantosPorcento = Result.withDefault 0 (String.toFloat porcentagem) }, Cmd.none )

        MudaQuantasPessoas pessoas ->
            ( { model | quantasPessoas = Result.withDefault 0 (String.toFloat pessoas) }, Cmd.none )



---- VIEW ----


criaCampo : String -> String -> (String -> Msg) -> Html Msg
criaCampo nome legenda evento =
    div []
        [ label [ for nome ] [ text legenda ]
        , input
            [ type_ "num"
            , id nome
            , onInput evento
            , size 4
            ]
            []
        ]


view : Model -> Html Msg
view model =
    let
        quantoBebemos =
            model.umaCerveja * model.quantasCervejas

        custoTotal =
            quantoBebemos + (quantoBebemos * (model.quantosPorcento / 100))

        custoPorPessoa =
            custoTotal / model.quantasPessoas |> Round.round 2
    in
    div
        [ style
            [ ( "font-size", "2.2rem" )
            , ( "display", "flex" )
            , ( "flex-direction", "column" )
            ]
        ]
        [ h1 [] [ text "🍺 Cervejapp 🍺" ]
        , criaCampo "umaCerveja" "💲🍺 x " MudaPrecoDaCerveja
        , criaCampo "quantasCervejas" "🍻\x1F914 x " MudaQuantasCervejas
        , criaCampo "quantasPessoas" "👥🍺x " MudaQuantasPessoas
        , criaCampo "quantasCervejas" "\x1F935\x1F911 x " MudaPorcentagem
        , h3 [] [ text ("💸😿 = R$ " ++ custoPorPessoa) ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
