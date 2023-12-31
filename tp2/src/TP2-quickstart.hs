-- PFL 2023/24 - Haskell practical assignment quickstart
-- Updated on 15/12/2023

-- Part 1

-- Do not modify our definition of Inst and Code
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# LANGUAGE BlockArguments #-}
import Data.List (intercalate)
import Data.Bool
import qualified Data.Map as Map

data Inst =
  Push Integer | Add | Mult | Sub | Tru | Fals | Equ | Le | And | Neg | Fetch String | Store String | Noop |
  Branch Code Code | Loop Code Code
  deriving Show
type Code = [Inst]

data StackElements = VInt Integer | VBool Bool

instance Show StackElements where
  show (VInt n) = show n
  show (VBool b) = show b


type Stack = [StackElements]

isEmpty :: Stack -> Bool
isEmpty [] = True
isEmpty _ = False

createEmptyStack :: Stack
createEmptyStack = []

stack2Str :: Stack -> String
stack2Str [] = ""
stack2Str stack = intercalate "," (map (\x -> case x of 
  VInt n -> show n; 
  VBool b -> show b) 
  stack)

type State = Map.Map String StackElements

createEmptyState :: State
createEmptyState = Map.empty

state2Str :: State -> String
state2Str state = intercalate "," (map (\(x,y) -> x ++ "=" ++ show y) (Map.toList state))


run :: (Code, Stack, State) -> (Code, Stack, State)
run ([],stack,state) = ([],stack,state)
run ((Push n):code, stack, state) = run (code, VInt n : stack , state)
run (Add:code,(VInt x):(VInt y):stack,state) = run (code, (VInt ( x + y)):stack, state)
run (Mult:code,(VInt x):(VInt y):stack,state) = run (code, (VInt ( x * y)):stack, state)
run (Sub:code,(VInt x):(VInt y):stack,state) = run (code, (VInt ( x - y)):stack, state)
run (Tru:code,stack,state) = run (code, VBool True:stack, state)
run (Fals:code,stack,state) = run (code, VBool False:stack, state)
run (Equ:code,((VBool x): (VBool y):stack),state) = run (code, VBool (x == y):stack, state)
run (Equ:code , (VInt x):(VInt y):stack,state)  
  |  x == y = run(code, VBool True:stack, state)
  | otherwise = run(code, VBool False:stack, state)
run (Le:code , (VInt x):(VInt y):stack,state) = run (code, (VBool ( x <= y)):stack, state)
run (And:code , (VBool x):(VBool y):stack,state) = run (code, (VBool ( x && y)):stack, state)
run (Neg:code,(VBool x:stack),state) = run (code, (case x of True -> VBool False; False -> VBool True):stack, state)
run (Fetch n:code, stack, state) = case Map.lookup n state of Just n -> run(code,n: stack, state);  Nothing -> error "Run-time error"
run (Store n:code,(val:stack),state) = run (code, stack, Map.insert n val state)
run (Noop:code,stack,state) = run (code, stack, state)
run (Branch code1 code2:code,(VBool True):stack,state) = run (code1 ++ code, stack, state)
run (Branch code1 code2:code,(VBool False):stack,state) = run (code2 ++ code, stack, state)
run (Loop code1 code2:code,stack,state) = run (code1 ++ [Branch (code2 ++ [Loop code1 code2]) [Noop]] ++ code, stack, state)
run (_,_,_) = error "Run-time error"




-- To help you test your assembler
testAssembler :: Code -> (String, String)
testAssembler code = (stack2Str stack, state2Str state)
  where (_,stack,state) = run(code, createEmptyStack, createEmptyState)

-- Examples:
-- testAssembler [Push 10,Push 4,Push 3,Sub,Mult] == ("-10","") passa
-- testAssembler [Fals,Push 3,Tru,Store "var",Store "a", Store "someVar"] == ("","a=3,someVar=False,var=True") passa
-- testAssembler [Fals,Store "var",Fetch "var"] == ("False","var=False") passa
-- testAssembler [Push (-20),Tru,Fals] == ("False,True,-20","") passa
-- testAssembler [Push (-20),Tru,Tru,Neg] == ("False,True,-20","") passa 
-- testAssembler [Push (-20),Tru,Tru,Neg,Equ] == ("False,-20","") passa
-- testAssembler [Push (-20),Push (-21), Le] == ("True","") passa 
-- testAssembler [Push 5,Store "x",Push 1,Fetch "x",Sub,Store "x"] == ("","x=4") passa
-- testAssembler [Push 10,Store "i",Push 1,Store "fact",Loop [Push 1,Fetch "i",Equ,Neg] [Fetch "i",Fetch "fact",Mult,Store "fact",Push 1,Fetch "i",Sub,Store "i"]] == ("","fact=3628800,i=1") passa
-- If you test:
-- testAssembler [Push 1,Push 2,And]
-- You should get an exception with the string: "Run-time error" certo
-- If you test:
-- testAssembler [Tru,Tru,Store "y", Fetch "x",Tru] 
-- You should get an exception with the string: "Run-time error" certo


-- Part 2

-- TODO: Define the types Aexp, Bexp, Stm and Program

data Aexp = N Integer | V String | AddA Aexp Aexp | SubA Aexp Aexp | MultA Aexp Aexp deriving Show

data Bexp = IntEq Aexp Aexp | BoolEq Bexp Bexp | Leq Aexp Aexp | AndB Bexp Bexp | NegB Bexp | TruB | FalsB deriving Show

data Stm = If Bexp [Stm] [Stm] | While Bexp [Stm] | Assign String Aexp | AssignB String Bexp | Seq [Stm] | Skip deriving Show

type Program = [Stm]

compA :: Aexp -> Code
compA (N n) = [Push n]
compA (V x) = [Fetch x]
compA (AddA a1 a2) = compA a1 ++ compA a2 ++ [Add]
compA (SubA a1 a2) = compA a1 ++ compA a2 ++ [Sub]
compA (MultA a1 a2) = compA a1 ++ compA a2 ++ [Mult]


compB :: Bexp -> Code
compB (IntEq a1 a2) = compA a1 ++ compA a2 ++ [Equ]
compB (BoolEq b1 b2) = compB b1 ++ compB b2 ++ [Equ]
compB (Leq a1 a2) = compA a1 ++ compA a2 ++ [Le]
compB (AndB b1 b2) = compB b1 ++ compB b2 ++ [And]
compB (NegB b) = compB b ++ [Neg]
compB TruB = [Tru]
compB FalsB = [Fals]

compile :: Program -> Code
compile [] = []
compile (If b s1 s2:xs) = compB b ++ [Branch (compile s1) (compile s2)] ++ compile xs
compile (If b s1 []:xs) = compB b ++ [Branch (compile s1) [Noop]] ++ compile xs
compile (While b s:xs) = [Loop (compB b) (compile s)] ++ compile xs
compile (Assign x a:xs) = compA a ++ [Store x] ++ compile xs
compile (AssignB x b:xs) = compB b ++ [Store x] ++ compile xs
compile (Seq s:xs) = compile s ++ compile xs


data Token = TokIf | TokThen | TokElse | TokWhile | TokDo | TokSkip | TokAssign | TokSemi | TokLParen | TokRParen | TokInt Integer | TokVar String | TokPlus | TokMinus | TokMult | TokDiv | TokEq | TokLeq | TokAnd | TokNot | TokTrue | TokFalse deriving (Show, Eq)

--parse :: String -> Program
--parse = 

-- To help you test your parser
--testParser :: String -> (String, String)
--testParser programCode = (stack2Str stack, state2Str state)
--  where (_,stack,state) = run(compile (parse programCode), createEmptyStack, createEmptyState)

-- Examples:
-- testParser "x := 5; x := x - 1;" == ("","x=4")
-- testParser "x := 0 - 2;" == ("","x=-2")
-- testParser "if (not True and 2 <= 5 = 3 == 4) then x :=1; else y := 2;" == ("","y=2")
-- testParser "x := 42; if x <= 43 then x := 1; else (x := 33; x := x+1;);" == ("","x=1")
-- testParser "x := 42; if x <= 43 then x := 1; else x := 33; x := x+1;" == ("","x=2")
-- testParser "x := 42; if x <= 43 then x := 1; else x := 33; x := x+1; z := x+x;" == ("","x=2,z=4")
-- testParser "x := 44; if x <= 43 then x := 1; else (x := 33; x := x+1;); y := x*2;" == ("","x=34,y=68")
-- testParser "x := 42; if x <= 43 then (x := 33; x := x+1;) else x := 1;" == ("","x=34")
-- testParser "if (1 == 0+1 = 2+1 == 3) then x := 1; else x := 2;" == ("","x=1")
-- testParser "if (1 == 0+1 = (2+1 == 4)) then x := 1; else x := 2;" == ("","x=2")
-- testParser "x := 2; y := (x - 3)*(4 + 2*3); z := x +x*(2);" == ("","x=2,y=-10,z=6")
-- testParser "i := 10; fact := 1; while (not(i == 1)) do (fact := fact * i; i := i - 1;);" == ("","fact=3628800,i=1")