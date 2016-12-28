import functools

# Decorator without argument
def my_decorator(func):
    @functools.wraps(func)
    def function_that_runs_func(*args, **kwargs):
        print("something")
        func(*args, **kwargs)
        print("do something")
    return function_that_runs_func

# Decorator with argument : 3 levels
def decorator_with_argument(argument):
    def my_decorator(func):
        @functools.wraps(func)
        def function_that_runs_func(*args, **kwargs):
            print("something")
            if argument == 'toto'
                func(*args, **kwargs)
            else:
                print("do something else")

            print("do something")
        return function_that_runs_func
    return my_decorator
