
while(true)
do
  dd  if=/dev/random  of=test.data  bs=1024000  count=100000000
  sleep 2
done
