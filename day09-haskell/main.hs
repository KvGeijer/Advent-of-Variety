import Control.Arrow
import Text.Parsec


data Streamed = Group [Streamed] | Garbage Int
    deriving (Show)

-- Could be made more clear as the &&&, splitting the input is not standard
main :: IO ()
main = do
    interact $ either show (show. ((getGroupScore 1) &&& getTrashScore)) . parse parseGroup ""
    putStr "\n"

getTrashScore :: Streamed -> Int
getTrashScore (Group pieces) = sum . map getTrashScore $ pieces
getTrashScore (Garbage pieces) = pieces

getGroupScore ::  Int -> Streamed -> Int
getGroupScore _ (Garbage _) = 0
getGroupScore depth (Group subs) = (+depth) . sum . map (getGroupScore (depth + 1)) $ subs


parseGroup :: Parsec String () Streamed
parseGroup = do
    char '{'
    streamed <- parseThings
    char '}'

    return $ Group streamed

parseThings :: Parsec String () [Streamed]
parseThings = sepBy parseThing (char ',')

parseThing :: Parsec String () Streamed
parseThing = try parseGroup <|> parseGarbage


parseGarbage :: Parsec String () Streamed
parseGarbage = do
    char '<'
    pieces <- many parseOneGarbage
    char '>'
    return $ Garbage $ sum pieces

-- Sort of ugly that this only returns 1 or 0. More clean with "Maybe Char" probably
parseOneGarbage :: Parsec String () Int
parseOneGarbage = do
    (try (noneOf "!>") >> return 1)
    <|> (parseNegation >> return 0)

parseNegation = do
    char '!'
    anyChar