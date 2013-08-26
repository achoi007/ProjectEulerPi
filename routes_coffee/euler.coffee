# CoffeeScript

uu = require "underscore"

module.exports = (app) ->
    app.namespace '/euler', () -> 
        app.get '/', index
        for prob in problems
            do(prob) ->
                name = "problem#{prob}"
                app.get "/#{name}", question(prob, name)
                app.post "/#{name}", answer(prob, name)
                null

###
The list of problem numbers.  Each problem must have:
 * problemN_question - message string for the question
 * problemN_answer - message string for the answer
 * problemN_solver() - solver to return an answer
See problem0 below for an example.
### 
problems = [1,8]

index = (req, res) ->
    msg =
        title: "Welcome to Project.Euler solutions"
        problems: problems
    res.render 'euler', msg

# Asks a question
question = (problem_num, name) ->
    (req, res) ->
        q = 
            num: problem_num
            msg: eval("#{name}_question")
        res.render 'question', q

# Gives out answer
answer = (problem_num, name) ->
    (req, res) ->
        a =
            num: problem_num
            msg: eval("#{name}_answer")
            val: eval("#{name}_solver")(+req.body.n)    # str to num
        res.render 'answer', a
 
###
Problem 0
###

problem0_question = "What is the meaning of life?"
problem0_answer = "The meaning of life is "
problem0_solver = (n) -> 
    s = "indeed" if n == 42
    s = "not" if n != 42
    s + " #{n}"

###
Problem 1
Find the sum of all the multiples of 3 or 5 below 1000.
###

problem1_question = "Sum of all multiples of 3 or 5 below"
problem1_answer = "The sum is"
problem1_solver = (n) ->
    nums = (i for i in [1...n] when (i % 3 == 0 or i % 5 == 0))
    sum = 0
    nums.forEach (i) -> sum += i
    sum

###
Problem 8
Find the greatest product of five consecutive digits in 
the 1000-digit number.
###

problem8_question = "Great product of N consecutive digits"
problem8_answer = "The product is"
problem8_solver = (n) ->

    numStr = """
73167176531330624919225119674426574742355349194934
96983520312774506326239578318016984801869478851843
85861560789112949495459501737958331952853208805511
12540698747158523863050715693290963295227443043557
66896648950445244523161731856403098711121722383113
62229893423380308135336276614282806444486645238749
30358907296290491560440772390713810515859307960866
70172427121883998797908792274921901699720888093776
65727333001053367881220235421809751254540594752243
52584907711670556013604839586446706324415722155397
53697817977846174064955149290862569321978468622482
83972241375657056057490261407972968652414535100474
82166370484403199890008895243450658541227588666881
16427171479924442928230863465674813919123162824586
17866458359124566529476545682848912883142607690042
24219022671055626321111109370544217506941658960408
07198403850962455444362981230987879927244284909188
84580156166097919133875499200524063689912560717606
05886116467109405077541002256983155200055935729725
71636269561882670428252483600823257530420752963450    
"""

    # From str into an array of digits
    digits = (+c for c in numStr)

    # How many digits for each number
    len = n

    # Function to compute product of all digits starting at p
    calcNum = (p) ->
        digits[p ... p + len].reduce ((t, s) -> t * s), 1

    # Current max product
    currProd = maxProd = calcNum 0
    maxPos = 0

    # Calculate the product of 5-digit number starting at p position
    for p in [1 .. digits.length - len]
        if currProd == 0
            currProd = calcNum p
        else
            # Smart logic to reduce number of computations by removing first factor and adding
            # last factor
            currProd = currProd / digits[p - 1] * digits[p + len - 1]

        if currProd > maxProd
            maxProd = currProd
            maxPos = p

    [maxProd, digits[maxPos ... maxPos + len]]
    




