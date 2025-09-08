#Assignment 2: Simple Calculator

while True:
    operation = int(input("""What do you want to calculate?:
        1. Sum
        2. Difference
        3. Product
        4. Divide         
        5. Exit        : """))
    print("\n")

    if operation == 5: 
        print("exiting...")
        break

    if operation not in [1, 2, 3, 4]:
        print("Please choose 1-5 only\n")
        continue

    num1 = int(input("Enter first number: "))
    num2 = int(input("Enter second number: "))
    print("\n")


    match operation:
        case 1:
            print(f"sum = {num1 + num2}\n")

        case 2:
            print(f"difference = {num1 - num2}\n")

        case 3:
            print(f"product = {num1 * num2}\n")

        case 4:
            if num2 == 0:
                print("can't be divided by zero")
                continue
            
            print(f"division = {num1 / num2}\n")

