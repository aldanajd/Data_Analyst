def container_splitter(container: list):
    for idx, element in enumerate(container):
        element = element.text
        element = element.strip()
        container[idx] = element.split("\n")

def reset_dictionary(my_dict):
    for key in my_dict.keys():
        my_dict[key] = [] 

list_to_string = lambda my_list: "".join(my_list)