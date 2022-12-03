using System;

static class Chao
{
    private static string lAlphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
    private static string rAlphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

    public static string Encrypt(string plainText)
    {
       char[] left = lAlphabet.ToCharArray();
       char[] right = rAlphabet.ToCharArray();
       char[] pText = plainText.ToCharArray();
       char[] cText = new char[pText.Length];
       char[] temp = new char[26];
       int index;
       char store;

       for(int i = 0; i < pText.Length; i++)
       {
          Console.WriteLine("{0}  {1}", new string(left), new string(right));

          index = Array.IndexOf(right, pText[i]);
          cText[i] =left[index];
          if (i == pText.Length - 1) break;

          // permute left

          for(int j = index; j < 26; j++) temp[j - index] = left[j];
          for(int j = 0; j < index; j++) temp[26 - index + j] = left[j];
          store = temp[1];             
          for(int j = 2; j < 14; j++) temp[j - 1] = temp[j];
          temp[13] = store;
          temp.CopyTo(left, 0);

          // permute right
 
          for(int j = index; j < 26; j++) temp[j - index] = right[j];
          for(int j = 0; j < index; j++) temp[26 - index + j] = right[j];
          store = temp[0];
          for(int j = 1; j < 26; j++) temp[j - 1] = temp[j];
          temp[25] = store;
          store = temp[2];
          for(int j = 3; j < 14; j++) temp[j - 1] = temp[j];
          temp[13] = store;
          temp.CopyTo(right, 0);         
       }

       return new string(cText);
    }

    public static string Decrypt(string cipherText)
    {
       char[] left = lAlphabet.ToCharArray();
       char[] right = rAlphabet.ToCharArray();
       char[] cText = cipherText.ToCharArray();
       char[] pText = new char[cText.Length];
       char[] temp = new char[26];
       int index;
       char store;

       for(int i = 0; i < cText.Length; i++)
       {
          // Console.WriteLine("{0}  {1}", new string(left), new string(right));

          index = Array.IndexOf(left, cText[i]);
          pText[i] = right[index];
          if (i == cText.Length - 1) break;

          // permute left

          for(int j = index; j < 26; j++) temp[j - index] = left[j];
          for(int j = 0; j < index; j++) temp[26 - index + j] = left[j];
          store = temp[1];             
          for(int j = 2; j < 14; j++) temp[j - 1] = temp[j];
          temp[13] = store;
          temp.CopyTo(left, 0);

          // permute right

          for(int j = index; j < 26; j++) temp[j - index] = right[j];
          for(int j = 0; j < index; j++) temp[26 - index + j] = right[j];
          store = temp[0];
          for(int j = 1; j < 26; j++) temp[j - 1] = temp[j];
          temp[25] = store;
          store = temp[2];
          for(int j = 3; j < 14; j++) temp[j - 1] = temp[j];
          temp[13] = store;
          temp.CopyTo(right, 0);        
       }

       return new string(pText);
   }
}

class Program
{ 
    static void Main()
    {      
       string plainText = "WELLDONEISBETTERTHANWELLSAID";
       Console.WriteLine("The original plainText is : {0}", plainText);
       Console.WriteLine("\nThe left and right alphabets after each permutation during encryption are\n"); 
       string cipherText = Chao.Encrypt(plainText);     
       Console.WriteLine("\nThe ciphertext is {0}", cipherText);
       string plainText2 = Chao.Decrypt(cipherText);
       Console.WriteLine("\nThe recovered plaintext is {0}", plainText2);
       Console.ReadKey();
    }   
}
