
defmodule Problems do

    # miscellaneous functions

    def pow(a, b), do: pow a, b, 1
    defp pow(_, 0, result), do: result
    defp pow(a, b, result), do: pow a, b-1, result*a

    def map(list, func), do: map(list, func, [])
    defp map([], _, result), do: reverse result
    defp map([head|tail], func, result), do: map tail, func, [func.(head)|result]

    def conmap(list, func), do: conmap list, func, []
    defp conmap([], _, result), do: reverse result
    defp conmap([head|tail], func, result), do: conmap(tail, func, func.(head)++result)

    def sort(list), do: sort list, &1<&2
    def sort([], _), do: []
    def sort([pivot|list], func), do: sort(filter(list, fn(e)->func.(e, pivot)end), func)++[pivot|sort(filter(list, fn(e)->not func.(e, pivot)end), func)]

    def filter(list, func), do: filter list, func, []
    defp filter([], _, result), do: reverse result
    defp filter([head|tail], func, result) do
        if func.(head) do
            filter tail, func, [head|result]
        else
            filter tail, func, result
        end
    end

    # 01 get last element of list 
    def last([head]), do: head
    def last([_|tail]), do: last tail

    # 02 get one but last element of list
    def but_last([first, _]), do: first
    def but_last([_|tail]), do: but_last tail

    # 03 get kth element of list
    def kth([head|_], 0), do: head
    def kth([_|tail], k) when k>0, do: kth tail, k-1

    # 04 get list length
    def len(list), do: len list, 0
    defp len([], result), do: result
    defp len([_|tail], result), do: len tail, result+1

    # 05 reverse list
    def reverse(list), do: reverse list, []
    defp reverse([], result), do: result
    defp reverse([head|tail], result), do: reverse tail, [head|result]

    # 06 find out whether is list palindrom
    def is_palindrom(list), do: is_palindrom [], list
    defp is_palindrom(left, right) when length(left)==length(right), do: left==right
    defp is_palindrom(left, [_|right]) when length(left)==length(right), do: left==right 
    defp is_palindrom(left, [middle|right]), do: is_palindrom [middle|left], right

    # 07 flatten list
    def flatten([]), do: []
    def flatten([head|tail]) when is_list(head), do: flatten(head)++flatten(tail)
    def flatten([head|tail]), do: [head|flatten(tail)]

    # 08 delete repeating elements
    def delete_repetition(list), do: delete_repetition list, []
    defp delete_repetition([head], result), do: reverse [head|result]
    defp delete_repetition([first, first|tail], result), do: delete_repetition [first|tail], result
    defp delete_repetition([first, second|tail], result), do: delete_repetition [second|tail], [first|result]

    # 09 pack repeating elements into sublists
    def pack(list), do: pack list, [], []
    defp pack([], repetition, result), do: reverse [repetition|result]
    defp pack([head|tail], [], result),  do: pack tail, [head], result
    defp pack([head|tail], [repetition_head|repetition_tail], result) when head==repetition_head, do: pack tail, [head, repetition_head|repetition_tail], result
    defp pack([head|tail], [repetition_head|repetition_tail], result), do: pack tail, [head], [[repetition_head|repetition_tail]|result]

    # 10 compress repeating elements into tuples {element, repetition}
    def compress_pack(list), do: map pack(list), fn([head|tail])-> {length(tail)+1, head} end 

    # 11 compress repeating elements into tuples {element, repetition}, except for repetition 1
    def compress_pack2(list), do: map pack(list), fn([head|tail])-> compress_element(head, length(tail)+1) end 

    # 12 compress repeating elements into tuples {element, repetition}, except for repetition 1, withou use of function pack/1
    def compress(list), do: compress list, 0, []
    defp compress([head], number_of_repetitions, result), do: reverse [compress_element(head, number_of_repetitions+1)|result]
    defp compress([first, first|tail], number_of_repetitions, result), do: compress [first|tail], number_of_repetitions+1, result
    defp compress([first, second|tail], number_of_repetitions, result), do: compress [second|tail], 0, [compress_element(first, number_of_repetitions+1)|result]

    defp compress_element(element, 1), do: element
    defp compress_element(element, number_of_repetitions), do: {number_of_repetitions, element}

    # 13 decompress repeating elements (see 10-12)
    def decompress(list), do: decompress list, []
    defp decompress([], result), do: result
    defp decompress([head|tail], result), do: decompress tail, result++decompress_element(head)

    defp decompress_element({number, element}), do: decompress_element {number, element}, []
    defp decompress_element(element), do: [element]
    defp decompress_element({1, element}, result), do: [element|result]
    defp decompress_element({number, element}, result), do: decompress_element {number-1, element}, [element|result]

    # 14 duplicate every element in list
    def duplicate(list), do: duplicate list, []
    defp duplicate([], result), do: reverse result
    defp duplicate([head|tail], result), do: duplicate tail, [head, head|result]

    # 15 replicate every element in list number-times
    def replicate(_, 0), do: []
    def replicate(list, number), do: replicate list, number, number, []
    defp replicate([], _, _, result), do: reverse result
    defp replicate([head|tail], 1, number, result), do: replicate tail, number, number, [head|result]
    defp replicate([head|tail], repeat_head, number, result), do: replicate [head|tail], repeat_head-1, number, [head|result]

    # 16 drop every number-th element in list
    def drop(list, number) when number>=1, do: drop list, number, number, []
    defp drop([], _, _, result), do: reverse result
    defp drop([_|tail], 1, number, result), do: drop tail, number, number, result
    defp drop([head|tail], to_drop, number, result), do: drop tail, to_drop-1, number, [head|result]

    # 17 split list into two, len is length of first one
    def split(list, len) when len>=0, do: split [], list, len
    defp split(left, right, 0), do: {reverse(left), right}
    defp split(left, [middle|right], len), do: split [middle|left], right, len-1

    # 18 get slice from list, a is index of first element of slice and b index of last
    def slice(list, a, b) when a<=b and a>=0, do: slice list, a, b, []
    defp slice([head|_], _, b,  result) when b<=0, do: reverse [head|result]
    defp slice([head|tail], a, b, result) when a<=0, do: slice tail, a-1, b-1, [head|result]
    defp slice([_|tail], a, b, result), do: slice tail, a-1, b-1, result

    # 19 rotate list left number-times
    def rotate(list, number) do
        number_adjusted=rem(number, length(list))
        {left, right}=split(list, number_adjusted)
        right++left
    end

    # 20 remove number-th element
    def remove(list, number) when number>=0, do: remove [], list, number
    defp remove(left, [_|right], 0), do: reverse(left)++right
    defp remove(left, [head|right], number), do: remove [head|left], right, number-1

    # 21 insert element into list at position number
    def insert(list, element, number) when number >=0, do: insert element, list, number, []
    defp insert(element, right, 0, left), do: reverse(left)++[element|right]
    defp insert(element, [head|right], number, left), do: insert element, right, number-1, [head|left]

    # 22 generate list of integers from a to b
    def range(a, b) when a<=b, do: range a, b, []
    defp range(b, b, result), do: reverse [b|result]
    defp range(a, b, result), do: range a+1, b, [a|result]

    # 23 randomly select number elements from list
    def random_select(list, number), do: random_select list, number, []
    defp random_select(_, 0, result), do: result
    defp random_select(list, number, result) when number>0 do
        index=Kernel.round(:random.uniform()*(len(list)-1))
        random_select(remove(list, index), number-1, [kth(list, index)|result])
    end

    # 24 select number numbers from range 1 to max_value
    def lotto_select(max_value, number), do: random_select range(1, max_value), number

    # 25 get random permutation of list
    def random_permutation(list), do: random_select list, length(list)

    # 26 get all combinations of elements from list, every combination has length len
    def combinations(list, len), do: comb [], list, len

    defp comb([], list, 1), do: map list, fn(e)-> [e] end
    defp comb(object, list, 1), do: map list, fn(e)-> [e|object] end
    defp comb([], list, len), do: conmap list, fn(e)-> comb([e], List.delete(list, e), len-1) end
    defp comb(object, list, len), do: conmap list, fn(e)-> comb([e|object], List.delete(list, e), len-1) end

    # 27 divide people into groups of 2, 3 and 4
    def group234(people) when length(people)==9, do: map all_permutations(people), fn(e)-> groupify(e, [2,3,4]) end

    # 28 divide people into groups
    def group(people, groups), do: map all_permutations(people), fn(e)-> groupify(e, groups) end

    defp groupify(people, groups), do: groupify people, groups, []
    defp groupify([], [], result), do: reverse result
    defp groupify(people, [head|tail], result) do
        {group, others}=split(people, head)
        groupify others, tail, [group|result]
    end

    defp all_permutations(list), do: all_permutations [], list
    defp all_permutations(object, []), do: [object]
    defp all_permutations(object, list), do: conmap list, fn(e)-> all_permutations([e|object], List.delete(list, e)) end

    # 29 sort list of lists according to their length
    def lsort(list), do: sort list, fn(a, b)-> length(a)<length(b) end

    # 30 sort list of lists according to their length frequency
    def lfsort(list), do:  sort list, fn(a, b)-> length_frequency(list, length(a))<length_frequency(list, length(b)) end

    defp length_frequency(list, e), do: length_frequency list, e, 0
    defp length_frequency([], _, result), do: result
    defp length_frequency([head|tail], e, result) when length(head)==e, do: length_frequency tail, e, result+1
    defp length_frequency([_|tail], e, result), do: length_frequency tail, e, result

    # 31 determine whether number is prime
    def is_prime(number), do: number==last(sieve_of_eratosthenes(number))

    def sieve_of_eratosthenes(number), do: sieve_of_eratosthenes range(2, number), []
    defp sieve_of_eratosthenes([], result), do: reverse result
    defp sieve_of_eratosthenes([head|tail], result), do: sieve_of_eratosthenes filter(tail, fn(e)-> rem(e, head)!=0 end), [head|result]

    # 32 get greatest common divisor of integers a and b
    def gcd(a, 0), do: a
    def gcd(a, b), do: gcd(b, rem(a, b))

    # 33 determine whether numbers a and b are coprimes
    def coprime(a, b), do: gcd(a, b)==1 

    # 34 
    def totient_phi(1), do: 1
    def totient_phi(number), do: totient_phi(range(1, number-1), number, 0)
    defp totient_phi([], _, result), do: result
    defp totient_phi([head|tail], number, result) do 
        if coprime(head, number) do
            totient_phi tail, number, result+1
        else
            totient_phi tail, number, result
        end
    end

    # 35 get prime factors of number
    def prime_factors(1), do: [1]
    def prime_factors(number), do: prime_factors sieve_of_eratosthenes(number), number, []
    defp prime_factors([], _, result), do: reverse result
    defp prime_factors([head|tail], number, result) do
        if rem(number, head)==0 do
            prime_factors [head|tail], div(number, head), [head|result]
        else
            prime_factors tail, number, result
        end
    end

    # 36 get prime factors of number and their multiplicity
    def prime_factors_mult(1), do: [{1, 1}]
    def prime_factors_mult(number), do: prime_factors_mult sieve_of_eratosthenes(number), number, 0, []
    defp prime_factors_mult([], _, 0, result), do: reverse result
    defp prime_factors_mult([head|tail], number, multiplicity, result) do
        cond do
            rem(number, head)==0 ->
                prime_factors_mult [head|tail], div(number, head), multiplicity+1, result
            multiplicity==0 ->
                prime_factors_mult tail, number, 0, result
            true->
                prime_factors_mult tail, number, 0, [{multiplicity, head}|result]
        end
    end

    # 37
    def totient_phi2(1), do: 1
    def totient_phi2(number), do: totient_phi2 prime_factors_mult(number), 0
    defp totient_phi2([], result), do: result
    defp totient_phi2([{m, p}|tail], result), do: totient_phi2 tail, result+(p-1)*pow(p, (m-1))

    # 38

    # 39 get prime numbers greater or equal than a and lesser or equal than b
    def primes_range(a, b) when a<=b, do: filter sieve_of_eratosthenes(b), &1>=a

    # 40 for even number get {a, b} where a and b are primes and a+b=number (goldbach conjecture)
    def goldbach(number) when rem(number, 2)==0 do
        primes=sieve_of_eratosthenes(number)
        number_half=number/2
        left=filter primes, &1<=number_half
        right=filter primes, &1>=number_half
        goldbach left, 0, right, length(right)-1, number
    end
    defp goldbach(left, a, right, -1, number), do: goldbach left, a+1, right, length(right)-1, number
    defp goldbach(left, a, right, b, number) do
        if kth(left, a)+kth(right, b)==number do
            {kth(left, a), kth(right, b)}
        else
            goldbach left, a, right, b-1, number
        end
    end

    # 41 get goldbach conjecture (see 40) for every even number greater or equal than a and lesser or equal than b
    def goldbach_range(a, b) when a<=b and a>2 do
        numbers=range_even(a, b)
        primes=sieve_of_eratosthenes(b)
        goldbach_range numbers, primes, []
    end
    defp goldbach_range([], _, result), do: reverse result
    defp goldbach_range([head|tail], primes, result) do
        head_half=head/2
        left=filter(primes, &1<=head_half)
        right=filter(primes, fn(e)->e>=head_half and e<head end)
        head_result=goldbach left, 0, right, length(right)-1, head
        goldbach_range tail, primes, [head_result|result]
    end

    defp range_even(a, b) when a<=b, do: range_even a+rem(a, 2), b-rem(b, 2), []
    defp range_even(b, b, result), do: reverse [b|result]
    defp range_even(a, b, result), do: range_even a+2, b, [a|result]

    # 46 get truth table to given function func
    def table2(func) do
        [{true, true, func.(true, true)},{true, false, func.(true, false)},{false, true, func.(false, true)},{false, false, func.(false, false)}]
    end

    # 47

    # 48

    # 49
    def gray(1), do: ["0", "1"]
    def gray(n) when n>1 do
        left=gray n-1
        right=reverse left
        map(left, "0"<>&1)++map(right, "1"<>&1)
    end

end