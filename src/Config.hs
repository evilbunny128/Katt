{-# LANGUAGE OverloadedStrings #-}

module Config where

import qualified Data.Text as T
import qualified Data.Map as M
import Text.Parsec
    ( anyChar, char, string, manyTill, (<|>), many, parse, try )
import Text.Parsec.Text ( Parser )
import qualified Data.Text.IO as TIO

newtype Conf = Conf (M.Map T.Text T.Text) deriving (Show)

instance Semigroup Conf where
    (Conf a) <> (Conf b) = Conf $ M.union a b

instance Monoid Conf where
    mempty = Conf M.empty

config :: Parser Conf
config = do
    lines <- many (comment <|> emptyLine <|> section <|> keyVal)
    return $ mconcat lines
    

comment :: Parser Conf
comment = char ';' >> manyTill anyChar (char '\n') >> return mempty

emptyLine :: Parser Conf
emptyLine = char '\n' >> return mempty

section :: Parser Conf
section = char '[' >> manyTill anyChar (try (string "]\n")) >> return mempty

keyVal :: Parser Conf
keyVal = do
    key <- manyTill anyChar (char '=')
    value <- manyTill anyChar (char '\n')
    return . Conf $ M.singleton (T.pack key) (T.pack value)    


readConf :: IO Conf
readConf = do
    input <- TIO.readFile "config.ini"
    case parse config "" input of
        Left err -> error (show err)
        Right conf -> return conf


getToken :: Conf -> Maybe T.Text
getToken (Conf c) = M.lookup "AUTH-TOKEN" c

