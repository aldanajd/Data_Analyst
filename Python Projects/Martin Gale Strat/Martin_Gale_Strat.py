from numpy import unique


profit_list = []
loss_list = []
number_list = [10] #Contracts
multiply_by = 2 #If Loss: Multiply By
tp_rate = 1 #Take Profit Rate 1 = 100%
sl_rate = 1 #Stop Loss Rate 1 = 100%
count = 0
profit_popped = 0
loss_popped = 0

for number in number_list:

    last_number = number_list.pop()

    if last_number <= 1000000000:
        new_last_number = last_number * multiply_by
        number_list.append(round(last_number))      
        number_list.append(round(new_last_number))

for number in number_list:
    profit = number*tp_rate
    loss = number*sl_rate
    count += 1
    profit_list.append(profit)
    loss_list.append(loss)    
    profit_popped = profit_list.pop()+ profit_popped
    loss_popped = loss_list.pop() + loss_popped
 
    if loss_popped > 400: #Maximum Allowed to Lose
        break      
 
    dictionary = {"Trade #":str(count),
    "Qty":str(number),
    "Profit":str(round(profit,4)),
    "Loss":str(round(loss,4)),
    "Accumulated Loss":str(round(loss_popped,4)),
    }    

    print (dictionary)
    print ("\n")  
