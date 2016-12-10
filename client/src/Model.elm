module Model exposing (..)

import Dict exposing (Dict)
import Dict as D


-- Model


type alias ServerName =
    String


type alias ChannelName =
    String


type alias NamePair =
    ( ServerName, ChannelName )


type alias Line =
    { nick : String
    , text : String
    }


type alias Buffer =
    { lines : List Line
    , newLine : String
    }


type alias ServerInfo =
    { nick : String
    , newChannelName : ChannelName
    , serverBuffer : Buffer
    }


type alias BufferMap =
    Dict NamePair Buffer


type alias ServerInfoMap =
    Dict ServerName ServerInfo


type alias Model =
    { bufferMap : BufferMap
    , serverInfoMap : ServerInfoMap
    , currentServerName : ServerName
    , currentChannelName : ChannelName
    }


model : Model
model =
    Model
        (D.fromList
            [ ( ( "InitServer", "#a" ), Buffer [] "" )
            , ( ( "InitServer", "#b" ), Buffer [] "" )
            , ( ( "InitServer", "#c" ), Buffer [] "" )
            ]
        )
        (D.fromList
            [ ( "InitServer", ServerInfo "InitNick" "" errorBuffer ) ]
        )
        "InitServer"
        "#a"


errorBuffer : Buffer
errorBuffer =
    Buffer [ Line "NOTICE" "Currently not in a (valid) buffer." ] ""


getBuffer : Model -> ( ServerName, ChannelName ) -> Buffer
getBuffer model namePair =
    case D.get namePair model.bufferMap of
        Nothing ->
            errorBuffer

        Just buffer ->
            buffer


getServerInfo : Model -> ServerName -> ServerInfo
getServerInfo model serverName =
    case D.get serverName model.serverInfoMap of
        Just serverInfo ->
            serverInfo

        Nothing ->
            ServerInfo "ERROR" "" errorBuffer


getNick : Model -> ServerName -> String
getNick model serverName =
    getServerInfo model serverName
        |> (.nick)


getNewChannelName : Model -> ServerName -> ChannelName
getNewChannelName model serverName =
    getServerInfo model serverName
        |> (.newChannelName)


getServerBuffer : Model -> ServerName -> Buffer
getServerBuffer model serverName =
    getServerInfo model serverName
        |> (.serverBuffer)
