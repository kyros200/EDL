import Html exposing (text)

type alias Env = (String -> Int)
ambInicial : Env
ambInicial = \ask -> 0

--Exp
type Exp = Add Exp Exp
         |Sub Exp Exp
         |Mul Exp Exp
         |Div Exp Exp
         |Pot Exp Exp
         | Num Int
         | Var String

evalExp : Exp -> Env -> Int
evalExp exp env =
    case exp of
        Add exp1 exp2  -> (evalExp exp1 env) + (evalExp exp2 env) --Soma
        Sub exp1 exp2 -> (evalExp exp1 env) - (evalExp exp2 env) --Subtração
        Mul exp1 exp2 -> (evalExp exp1 env) * (evalExp exp2 env) --Multiplicação
        Div exp1 exp2 -> (evalExp exp1 env) // (evalExp exp2 env) --Divisao
        Pot exp1 exp2 -> (evalExp exp1 env) ^ (evalExp exp2 env) --Potencia (x^y)
        Num v             -> v
        Var var            -> (env var)
        
--Prog  
type Prog = Attr String Exp
          | Seq Prog Prog
          | If Exp Prog Prog
          | While Exp Prog Prog

evalProg : Prog -> Env -> Env
evalProg s env =
    case s of
        Seq s1 s2 -> --Sequencia de dois programas
            (evalProg s2 (evalProg s1 env))
            
        Attr var exp -> --Atriibuir exp em var
            let
                val = (evalExp exp env)
            in
                \ask -> if ask==var then val else (env ask)
                
        If exp prog1 prog2 -> --Se exp == 0, entao prog1, senao prog2
             evalProg ( 
                 if (evalExp exp env) == 0 then 
                     prog1 
                 else 
                     prog2  
                 ) env
             --Resumindo, If exp prog1 prog2 -> evalProg (prog1 OU prog2) env
                 
        While exp prog1 prog2 -> --Enquanto exp for >0, acontece o prog1, senão prog2 (esse progf2 pensei em apenas atribuir ret a alguma coisa, porem deixei mais generico)
            if (evalExp exp env > 0) then 
                evalProg (While exp prog1 prog2) (evalProg prog1 env) 
            else 
                evalProg prog2 env
            
--Resto
lang : Prog -> Int
lang p = ((evalProg p ambInicial) "ret") --Leitor inicial, quer o resultado de ret
        
pIf : Prog --Programa que mostra If, Div, Pot
pIf = If (Num 0) --Portanto esse if vai para o prog1
        (Attr "ret"   (Pot (Num 25) (Num 2) )) --25^2
        (Attr "ret" (Div (Num 8) (Num 4) )) --8/4
        
p : Prog --Programa que mostra While, Seq, Attr, Add e Sub em ação
p = Seq 
        (Seq (Attr "x" (Num 0)) (Attr "cont" (Num 10)) )
        (While (Var "cont") --Enquanto cont > 0
            (Seq (Attr "x" (Add (Var "x") (Num 2))) (Attr "cont" (Sub (Var "cont") (Num 1))) ) --x += 2  && cont -= 1
            (Attr "ret" (Var "x")) --ret = x
        )

main = text (toString (lang p)) -- rodando o programa p. lang p imprimirá o resultado da variavel ret