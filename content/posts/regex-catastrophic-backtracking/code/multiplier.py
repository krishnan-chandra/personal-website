import re
import time


def measure_regex_time_ns(multiplier: int):
    # Create input strings based on the multiplier
    input_str = 'a\nb\nc' * multiplier

    # Problematic regex pattern with potential for catastrophic backtracking
    problematic_pattern = re.compile(r'((\n*.*\n*)*)')

    # Simplified pattern that doesn't cause backtracking, with re.DOTALL flag and non-greedy matching
    simple_pattern_non_greedy = re.compile(r'(.*?)', re.DOTALL)

    # Measure time taken for matching with problematic pattern using re.search
    start_time = time.perf_counter_ns()
    regex_match = problematic_pattern.search(input_str)
    end_time = time.perf_counter_ns()
    problematic_time = end_time - start_time

    # Measure time taken for matching with simplified pattern using re.search
    start_time = time.perf_counter_ns()
    regex_match = simple_pattern_non_greedy.search(input_str)
    end_time = time.perf_counter_ns()
    simple_time_non_greedy = end_time - start_time

    return problematic_time, simple_time_non_greedy


def main():
    # Test the function with multiples for string length (1, 10, 100, 1000, 10000, 100000)
    multipliers = [int(10 ** i) for i in range(6)]
    for multiplier in multipliers:
        problematic_time, simple_time = measure_regex_time_ns(multiplier)
        print("Multiplier:", multiplier)
        print("Problematic Regex Time (ns):", problematic_time)
        print("Simple Regex Time (ns):", simple_time)
        print("Ratio of Times:", problematic_time / simple_time)
        print("-" * 30 + "\n" * 3)


if __name__ == "__main__":
    main()