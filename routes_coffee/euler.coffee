# CoffeeScript

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
problems = [1]

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


