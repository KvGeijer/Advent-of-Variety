import Data.Maybe

import Text.Parsec
import Text.Parsec.Char
import Text.Parsec.Expr

data Group = Group [Group] deriving (Show)
data Void

main :: IO ()
main = do
    interact $ either show (show.getScore 1) . parse parseGroup ""
    putStr "\n"

-- The score of each group is how deep it is
getScore ::  Int -> Group -> Int
getScore depth (Group subs) = foldr (+) depth $ map (getScore (depth + 1)) subs


parseGroup :: Parsec String () Group
parseGroup = do
    char '{'
    group <- (fmap Group parseThings)
    char '}'

    return group

parseThings :: Parsec String () [Group]
parseThings = do
    list_items <- (sepBy parseThing (char ','))
    return $ catMaybes list_items

parseThing :: Parsec String () (Maybe Group)
parseThing = do
    try (fmap (\x -> Just x) parseGroup)
    <|> (fmap (\x -> Nothing) parseGarbage)


parseGarbage :: Parsec String () (Maybe Group)
parseGarbage = do
    char '<'
    many parseOneGarbage
    char '>'
    return Nothing

parseOneGarbage = do
    try (noneOf "!>")
    <|> parseNegation

parseNegation = do
    char '!'
    anyChar