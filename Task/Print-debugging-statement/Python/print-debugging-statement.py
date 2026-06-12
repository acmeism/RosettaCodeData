import logging, logging.handlers

LOG_FILENAME = "logdemo.log"
FORMAT_STRING = "%(levelname)s:%(asctime)s:%(name)s:%(funcName)s:line-%(lineno)d: %(message)s"
LOGLEVEL = logging.DEBUG
'''
        CRITICAL    50
        ERROR       40
        WARNING     30  **DEFAULT
        INFO        20
        DEBUG       10
        NOTSET      0
        '''

def print_squares(number):
    logger.info("In print_squares")
    for i in range(number):
        print("square of {0} is {1}".format(i , i*i))
        logger.debug(f'square of {i} is {i*i}')

def print_cubes(number):
    logger.info("In print_cubes")
    for j in range(number):
        print("cube of {0} is {1}".format(j, j*j*j))
        logger.debug(f'cube of {j} is {j*j*j}')

if __name__ == "__main__":

    logger = logging.getLogger("logdemo")
    logger.setLevel(LOGLEVEL)
    handler = logging.FileHandler(LOG_FILENAME)
    handler.setFormatter(logging.Formatter(FORMAT_STRING))
    logger.addHandler(handler)

    print_squares(10)
    print_cubes(10)

    logger.info("All done")
