#include <stdio.h>

int main()
{
  for(int i = 255; i >= 0; i--)
  {
    printf("%02X\n", i);
  }
  return 0;
}
