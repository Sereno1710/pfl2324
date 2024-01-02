# TP2 - PFL 23/24

## Group Information
- **Group**: T03_G05

| Student number | Full name                  | Contribution |
| -------------- | -------------------------- | ------------ |
| 202108791      | Daniel José de Aguiar Gago | 50%          |
| 202108729      | José Miguel Sereno Santos  | 50%          |
  
## 1st Part

In this part of the assignement, we were asked to implement a stack-based machine.

#### Stack 


```haskell
data StackElements = VInt Integer | VBool Bool

instance Show StackElements where
  show (VInt n) = show n
  show (VBool b) = show b


type Stack = [StackElements]

createEmptyStack :: Stack
createEmptyStack = []
```

#### State

To facilitate operations involving the state, the implementation of the state was done using Data.Map library, which allows us to use a Map to represent the state.

```haskell
type State = Map.Map String StackElements

createEmptyState :: State
createEmptyState = Map.empty

```

#### Conversion to String

- The `stack2Str` function converts a `Stack` to a `String` by mapping the `StackElement` to a `String` and then concatenating the resulting list of `Strings`. Using the `intercalate` function from the `Data.List` library, we can add a comma between each element of the list.

- The `state2Str` function converts a `State` to a `String` by mapping the `StackElement` to a `String` and then concatenating the resulting list of `String`s. Using the `intercalate` function from the `Data.List` library, we can add a comma between each element of the list. The `Map` is converted to a list of tuples using the `toList` function from the `Data.Map` library. The list of tuples is then mapped to a list of `String`s, where each `String` is a tuple of the form `(key, value)`. 

```haskell

stack2Str :: Stack -> String
stack2Str [] = ""
stack2Str stack = intercalate "," (map (\x -> case x of 
  VInt n -> show n; 
  VBool b -> show b) 
  stack)

state2Str :: State -> String
state2Str state = intercalate "," (map (\(x,y) -> x ++ "=" ++ show y) (Map.toList state))```


#### Run

The `run` function is the main function of the this part of the assignment. It takes a tuple of the form `(Code,Stack,State)` and returns a tuple of the same form. Here we use pattern matching to match the different instructions and perform the corresponding operations. 

The `run` function is called recursively until the `Code` is empty and the final result is returned with all changes made to the stack and the state. In case of an error, the `run` function returns the error message. 

```haskell

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

```

#### Example Execution
- Example 1: testAssembler [Push 10,Push 4,Push 3,Sub,Mult] == ("-10","")
- Example 2: testAssembler [Push 5,Store "x",Push 1,Fetch "x",Sub,Store "x"] == ("","x=4")

# 2nd Part

In this part of the assignment, we were asked to implement a compiler for a simple imperative language. The compiler should translate a program written in the imperative language to a stack-based machine code.

For that to be possible, it was necessary to implement a lexer and a parser for the imperative language. As well as a compiler that translates the imperative language to a stack-based machine code.

This compiler requires the use of `Aexp`, `Bexp` and `Stm` data types. The `Aexp` data type represents arithmetic expressions, the `Bexp` data type represents boolean expressions and the `Stm` data type represents statements.

#### Arithmetic Expressions


```haskell
data Aexp = N Integer | V String | AddA Aexp Aexp | SubA Aexp Aexp | MultA Aexp Aexp deriving Show

compA :: Aexp -> Code
compA (N n) = [Push n]
compA (V x) = [Fetch x]
compA (AddA a1 a2) = compA a2 ++ compA a1 ++ [Add]
compA (SubA a1 a2) = compA a2 ++ compA a1 ++ [Sub]
compA (MultA a1 a2) = compA a2 ++ compA a1 ++ [Mult]

```

#### Boolean Expressions

```haskell

data Bexp = IntEq Aexp Aexp | BoolEq Bexp Bexp | Leq Aexp Aexp | AndB Bexp Bexp | NegB Bexp | TruB | FalsB | L Aexp Aexp | G Aexp Aexp | Geq Aexp Aexp deriving Show

compB :: Bexp -> Code
compB (IntEq a1 a2) = compA a2 ++ compA a1 ++ [Equ]
compB (BoolEq b1 b2) = compB b2 ++ compB b1 ++ [Equ]
compB (Leq a1 a2) = compA a2 ++ compA a1 ++ [Le]
compB (L a1 a2) = compA a2 ++ compA a1 ++ [Le, Neg]
compB (G a1 a2) = compA a2 ++ compA a1 ++ [Le, Neg]
compB (Geq a1 a2) = compA a2 ++ compA a1 ++ [Le, Neg, Equ]
compB (AndB b1 b2) = compB b2 ++ compB b1 ++ [And]
compB (NegB b) = compB b ++ [Neg]
compB TruB = [Tru]
compB FalsB = [Fals]
    
```

#### Statements

```haskell

data Stm = If Bexp [Stm] [Stm] | While Bexp [Stm] | Assign String Aexp | AssignB String Bexp | Seq [Stm] deriving Show

compile :: Program -> Code
compile [] = []
compile (If b s1 s2:xs) = compB b ++ [Branch (compile s1) (compile s2)] ++ compile xs
compile (If b s1 []:xs) = compB b ++ [Branch (compile s1) [Noop]] ++ compile xs
compile (While b s:xs) = [Loop (compB b) (compile s)] ++ compile xs
compile (Assign x a:xs) = compA a ++ [Store x] ++ compile xs
compile (AssignB x b:xs) = compB b ++ [Store x] ++ compile xs
compile (Seq s:xs) = compile s ++ compile xs

```

### Tokens

`Token` data type to represent the different tokens of the imperative language.

This data type is used in the lexer to represent the different tokens of the imperative language.

```haskell
data Token = TokIf | TokThen | TokElse | TokWhile | TokDo | TokAssign | TokSemi | TokLParen | TokRParen | TokInt Integer | TokVar String | TokPlus | TokMinus | TokMult | TokDiv | TokBEq | TokIEq | TokLeq | TokL | TokG| TokGeq | TokAnd | TokNot | TokTrue | TokFalse deriving (Show, Eq)
```

### Lexer

Lexer is used as a way to split the string into tokens, which are then used by the parser to parse the imperative language. To do this, we use pattern matching to match the different tokens and perform the corresponding operations. To facilitate the creation of negative numbers, we use the pattern matching to match the `(-` token and then add a `0 -` to the initial string.

```haskell
lexer :: String -> [Token]
lexer [] = []
lexer (' ':string) = lexer string
lexer ('\n':string) = lexer string
lexer ('\t':string) = lexer string
lexer ('\r':string) = lexer string
lexer ('(':'-':string) = lexer ('0':'-':string)
lexer ('(':string) = TokLParen : lexer string
lexer (')':string) = TokRParen : lexer string
lexer (';':string) = TokSemi : lexer string
lexer ('+':string) = TokPlus : lexer string
lexer ('-':string) = TokMinus : lexer string
lexer ('*':string) = TokMult : lexer string
lexer ('=':'=':string) = TokBEq : lexer string
lexer (':':'=':string) = TokAssign : lexer string
lexer ('>':'=':string) = TokGeq : lexer string
lexer ('<':'=':string) = TokLeq : lexer string
lexer ('<':string) = TokL : lexer string
lexer ('>':string) = TokG : lexer string
lexer ('&':'&':string) = TokAnd : lexer string
lexer ('!':'=':string) = TokIEq : lexer string
lexer ('!':string) = TokNot : lexer string
lexer ('i':'f':string) = TokIf : lexer string
lexer ('t':'h':'e':'n':string) = TokThen : lexer string
lexer ('e':'l':'s':'e':string) = TokElse : lexer string
lexer ('w':'h':'i':'l':'e':string) = TokWhile : lexer string
lexer ('d':'o':string) = TokDo : lexer string
lexer ('t':'r':'u':'e':string) = TokTrue : lexer string
lexer ('f':'a':'l':'s':'e':string) = TokFalse : lexer string
lexer (char:string)
  | isDigit char = TokInt (read (char : takeWhile isDigit string)) : lexer (dropWhile isDigit string)
  | isAlpha char = TokVar (char : takeWhile isAlphaNum string) : lexer (dropWhile isAlphaNum string)
  | otherwise = error ("Cannot parse " ++ [char])
```


## Parser
- Parse imperative programs from a string.
- Function: `parse :: String -> [Stm]`

### Syntactic Constraints
- Statements end with a semicolon.
- Variables start with a lowercase letter.
- Operator precedence for arithmetic and boolean expressions.
- Parentheses for priority.


