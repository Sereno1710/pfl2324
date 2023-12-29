module Stack (Stack, push, pop, top, empty, isEmpty) where

data StackElement = IntElement Int | BoolElement Bool deriving Show

newtype Stack = Stk [StackElement]

instance Show Stack where
  show (Stk xs) = show xs

push :: StackElement -> Stack -> Stack
push x (Stk xs) = Stk (x:xs)

pop :: Stack -> Stack
pop (Stk (_:xs)) = Stk xs
pop _ = error "Stack.pop: empty stack"

top :: Stack -> StackElement
top (Stk (x:_)) = x
top _ = error "Stack.top: empty stack"

empty :: Stack
empty = Stk []

isEmpty :: Stack -> Bool
isEmpty (Stk []) = True
isEmpty _ = False


