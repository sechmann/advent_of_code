import sys

numbers = {
    'zero': '0',
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
    '0': '0',
    '1': '1',
    '2': '2',
    '3': '3',
    '4': '4',
    '5': '5',
    '6': '6',
    '7': '7',
    '8': '8',
    '9': '9',
}


def to_number(s):
    for k, v in numbers.items():
        if s.startswith(k):
            return v
    return ''


with sys.stdin as lines:
    s = 0
    for line in lines:
        line = line.strip()
        first, last = "", ""
        length = len(line)

        for n in range(length):
            c = to_number(line[n:])
            if c != '':
                first = c
                break

        for n in range(length):
            c = to_number(line[length-1-n:])
            if c != '':
                last = c
                break

        n = first+''+last
        print(line, first, last, n)
        s += int(n)

    print(s)
