{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
-- 貌似https用到的，我不需要用
-- import Network.Wai.Handler.WarpTLS
import Servant

data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''User)

-- 这里意思就是的访问 127.0.0.1:8080/users
type API = "users" :> Get '[JSON] [User]

-- 此处定义端口为8080
startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = return users

users :: [User]
users = [ User 1 "Isaac" "Newton"
        , User 2 "Albert" "Einstein"
        ]

-- type API = Get '[JSON] Int

-- api :: Proxy API
-- api = Proxy

-- server :: Server API
-- server = return 10

-- app :: Application
-- app = serve api server