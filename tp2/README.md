# TP2 - PFL 23/24

## Group Information
- **Group**: T03_G05

| Student number | Full name                  | Contribution |
| -------------- | -------------------------- | ------------ |
| 202108791      | Daniel José de Aguiar Gago | 50%          |
| 202108729      | José Miguel Sereno Santos  | 50%          |
  
## Strategy
Describe the overall strategy your group used to approach and solve both parts of the assignment. Include any important decisions made when defining data structures and implementing functions.

---

## Assignment Description
1. ### Machine Representation
   Define a machine with configurations (c, e, s) where c is a list of instructions, e is the evaluation stack, and s is the storage.

   #### Instructions
   - push-n, add, mult, sub, true, false, eq, le, and, neg, fetch-x, store-x, noop, branch(c1, c2), loop(c1, c2).

   #### Arithmetic and Boolean Operations
   - add, mult, sub, eq, le, true, false, and others.

   #### Stack Modification Instructions
   - push-n, fetch-x, store-x, noop.

   #### Flow Control
   - branch(c1, c2), loop(c1, c2).

   #### Example Execution
   - Example 1: [push -1, fetch -x, add, store -x]
   - Example 2: [loop([true], [noop])]

2. ### Haskell Implementation
   - Define types to represent the machine's stack and state.
   - Implement functions:
     - `createEmptyStack :: Stack`
     - `createEmptyState :: State`
     - `stack2Str :: Stack -> String`
     - `state2Str :: State -> String`
     - `run :: (Code, Stack, State) -> (Code, Stack, State)`

---

# Part 2: Imperative Language Compilation

## Small Imperative Language
- Expressions and statements: Aexp, Bexp, Stm.
- Compilation to machine instructions.

### Compiler Functions
1. `compA :: Aexp -> Code`
2. `compB :: Bexp -> Code`
3. `compile :: [Stm] -> Code`

## Parser
- Parse imperative programs from a string.
- Function: `parse :: String -> [Stm]`

### Syntactic Constraints
- Statements end with a semicolon.
- Variables start with a lowercase letter.
- Operator precedence for arithmetic and boolean expressions.
- Parentheses for priority.

### Lexer
- Define `lexer :: String -> [String]` to split the string into tokens.

---

# Submission and Evaluation
- Submit a ZIP file named `PFLT P2 TXX GYY.ZIP`.
- Include README in PDF format and a `src` folder with the Haskell source code in `main.hs`.
- README should detail group information, contribution percentages, and the strategy used for solving both parts of the assignment.
