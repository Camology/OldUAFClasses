#Chain of Responsibility Example in Python CS372 
#Cameron K Titus
#referenced from https://sourcemaking.com/design_patterns/chain_of_responsibility/python/1 


import abc
class CarHandle(metaclass=abc.ABCMeta):
    def __init__(self, successor=None):
            self._successor = successor

    @abc.abstractmethod
    def handle_request(self):
        pass

class PrimaryCarHandle(CarHandle):
    def handle_request(self):
        if True:
            pass
        elif self._successor is not None:
            self._successor.handle_request()

class SecondaryCarHandle(CarHandle):
    def handle_request(self):
        if False:
            pass
        elif self._successor is not None:
            self._successor.handle_request()

def main():
    primary_handle = PrimaryCarHandle()
    secondary_handle = SecondaryCarHandle(primary_handle)
    secondary_handle.handle_request()

if __name__ == "__main__":
    main()

