require 'classnamer'

String == Classnamer::VERSION.class or fail

3 == Classnamer::PART_CANDIDATE_MATRIX.length or fail

Classnamer::PART_CANDIDATE_MATRIX.flatten(1).
  all? { |part_candidate| /\A[A-Z]/ =~ part_candidate } or fail

Classnamer.respond_to?(:generate) or fail

String == Classnamer.generate.class or fail

'42ObjecttrueSymbolFoo' == Classnamer.generate(
  [[42], [Object], [nil], [true], [:Symbol], ['Foo']]) or fail

lambda do
  matrix = [%w{A B C}, [], %w{A B}, %w{A}]
  prng_args = []
  prng = lambda { |n|
    prng_args << n
    0
  }
  Classnamer.generate matrix, prng
  [3, 0, 2, 1] == prng_args or fail
end.call

lambda do
  matrix = [%w{Foo0 Foo1 Foo2}, %w{Bar0 Bar1 Bar2}, %w{Baz0 Baz1 Baz2}]
  indices = [0, 2, 1]
  'Foo0Bar2Baz1' == Classnamer.generate(matrix, lambda { |_| indices.shift }) \
    or fail
end.call

'Foo' == Classnamer.generate([['Foo']]) or fail

'' == Classnamer.generate([]) or fail

'' == Classnamer.generate([[], [], []]) or fail

begin
  Classnamer.generate nil
rescue NoMethodError
else
  fail
end

begin
  Classnamer.generate Classnamer::PART_CANDIDATE_MATRIX, nil
rescue NoMethodError
else
  fail
end

begin
  Classnamer.generate [['Foo'], nil]
rescue NoMethodError
else
  fail
end

Classnamer::Generator == Classnamer::Generator.new.class or fail

Classnamer::Generator.new.respond_to?(:generate) or fail

lambda do
  matrix = [%w{Foo0 Foo1 Foo2}, %w{Bar0 Bar1 Bar2}, %w{Baz0 Baz1 Baz2}]
  indices = [0, 2, 1]
  generator = Classnamer::Generator.new(matrix, lambda { |_| indices.shift })
  'Foo0Bar2Baz1' == generator.generate or fail
end.call

puts 'Test finished.'
