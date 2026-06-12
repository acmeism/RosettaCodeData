using JuMP, GLPK

# cost vector
c = [3, 5, 7, 3, 2, 5];
N = size(c,1);

# constraints Ax (<,>,=) b
A = [1 1 1 0 0 0
     0 0 0 1 1 1
     1 0 0 1 0 0
     0 1 0 0 1 0
     0 0 1 0 0 1];
b = [ 25,  35,  20,  30,  10];
s = ['<', '<', '=', '=', '='];

# construct model
model = Model(GLPK.Optimizer)
@variable(model, x[i=1:N] >= 0, base_name="traded quantities")
cost_fn = @expression(model, c'*x)                                              # cost function
@constraint(model, C1, A[1:2,:]*x .<= b[1:2])                                   # inequality constraints
@constraint(model, C2, A[3:5,:]*x .== b[3:5])                                   # equality constraints
@objective(model, Min, cost_fn)                                                 # objective function

# solve model
status = JuMP.optimize!(model);
xstar = value.(x);
println("solution vector of quantities = ", xstar)
println("minimum total cost = ", JuMP.objective_value(model))

# recover Lagrange multipliers for post-optimality
λ = [JuMP.dual(C1[1]),JuMP.dual(C1[2])]
μ = [JuMP.dual(C2[1]),JuMP.dual(C2[2]),JuMP.dual(C2[3])]
