#Assignment 3: Even or Odd Checker

def even_or_odd(x):
    if x % 2 == 0:
        return "The number is even"
    else:
        return "The number is odd"
    
x = int(input("enter a number(even or odd): \n"))
print(even_or_odd(x))    
    