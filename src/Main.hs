{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.Text.IO as TIO
import qualified Data.Text as T
import Config
import Debug.Trace

import Control.Monad (when)
import Discord
import Discord.Types
import qualified Discord.Requests as R


main :: IO ()
main = do
    conf <- readConf
    cats <- getCats
    case getToken conf of
        Just tok -> runKatt tok cats
        Nothing -> TIO.putStrLn "Could not get token"


runKatt :: T.Text -> [T.Text] -> IO ()
runKatt tok cats = do
    userFacingError <- runDiscord $ def
        { discordToken = tok
        , discordOnEvent = eventHandler cats
        }
    TIO.putStrLn userFacingError
   

getCats :: IO [T.Text]
getCats = T.lines <$> TIO.readFile "catUrls.txt"


eventHandler :: [T.Text] -> Event -> DiscordHandler ()
eventHandler cats event = case event of
    MessageCreate m -> when (isCat (messageText m) && not (fromBot m)) $ do
        let n = read . varannan . show $ messageId m
        _ <- restCall 
            (R.CreateMessageEmbed 
                (messageChannel m) 
                "A Beautiful cat, just for you: "
                (def { createEmbedImage = Just $ CreateEmbedImageUrl (cats !! (n `mod` length cats))})
            )
        pure ()
    _ -> pure ()


varannan :: [a] -> [a]
varannan (x:_:xs) = x : varannan xs
varannan [x] = [x]
varannan [] = []

isCat :: T.Text -> Bool
isCat m = "cat" `T.isInfixOf` T.toLower m || "katt" `T.isInfixOf` T.toLower m 

fromBot :: Message -> Bool
fromBot m = userIsBot (messageAuthor m)

