import sys
import re


def main():
    lines = sys.stdin.readlines()

    leaf_regex = re.compile(r"(\w+) \(\d+\)")
    node_regex = re.compile(r"(\w+) \(\d+\) -> ((?:\w+(?:, )?)+)")

    carried_map = {}

    for line in lines:
        match = node_regex.match(line)
        if match:
            for carried in match.group(2).split(", "):
                carried_map[carried] = match.group(1)
    
    with open("gen.pl", 'w') as f:
        for (carried, carrier) in carried_map.items():
            f.write(f"carries({carrier}, {carried}).\n")

        f.write("""\nbottomCarrier(X) :- (carries(Y, X)
    -> bottomCarrier(Y)
    ; format('The bottom is: ~w~n', [X])
).""")
        f.write(f"\nresult :- bottomCarrier({carried}).\n")


if __name__ == "__main__":
    main()