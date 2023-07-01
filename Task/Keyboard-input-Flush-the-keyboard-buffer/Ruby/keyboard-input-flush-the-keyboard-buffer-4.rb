# Demonstration: discard input, then input a line from user.
puts 'Type anything for 2 seconds.'
sleep 2
$stdin.discard_input
print 'Enter a line? '
if line = $stdin.gets
then print 'Got line. ', line
else puts 'No line!'
end
