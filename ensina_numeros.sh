#!/usr/bin/env bash
FALAR=true
#apt install mbrola-us* mbrola-br* espeak-ng espeak

declare -a units=("" "one" "two" "three" "four" "five" "six" "seven" \
            "eight" "nine" "ten" "eleven" "twelve" "thirteen" "fourteen" \
            "fifteen" "sixteen" "seventeen" "eighteen" "nineteen")
declare -a tens=("" "" "twenty" "thirty" "forty" "fifty" "sixty" "seventy" "eighty" "ninety")

function convert() {
declare -i INTEGER=$1
if (($INTEGER == 0)); then
  echo "zero"
elif (($INTEGER < 0)); then
   echo -en "minus "
   convert $(($INTEGER*-1))
elif (($INTEGER < 20)); then
   echo -en ${units[$INTEGER]}
elif (($INTEGER < 100)); then
   echo -en ${tens[$(($INTEGER/10))]}
   (($INTEGER%10)) && echo -en " "
   echo -en ${units[$(($INTEGER%10))]}
elif (($INTEGER < 1000)); then
   echo -en "${units[$(($INTEGER/100))]} hundred"
   (($INTEGER%100)) && echo -en " "
   convert $(($INTEGER%100))
elif (($INTEGER < 1000000)); then
   convert $(($INTEGER/1000))
   echo -en " thousand"
   (($INTEGER%1000)) && echo -en " "
   convert $(($INTEGER%1000))
elif (($INTEGER < 1000000000)); then
   convert $(($INTEGER/1000000))
   echo -en " million"
   (($INTEGER%1000)) && echo -en " "
   convert $(($INTEGER%1000000))
else
   convert $(($INTEGER/1000000000))
   echo -en " billion"
   (($INTEGER%1000000000)) && echo -en " "
   convert $(($INTEGER%1000000000))
fi
}

clear
echo ""
echo "###########################################################################"
echo " Beiriz - Studing the Numbers - v2.1 - 13/05/2020"
echo "###########################################################################"
echo ""


if [[ -n "$1" && "$1" -gt -1 && "$2" && "$2" -gt 0 ]];
then
inicio="$1"
fim="$2"
echo "- Activity with numbers for $inicio to $fim..."
echo "- Enter [CTRL + C] at any time to end."
echo "- Enter [number name]+[ENTER] in each answer."

if [ "$FALAR" = true ]
then
  comando_voz_portuguese="`type -p espeak-ng` -s 100 -vmb/mb-br4"
  comando_voz_english="`type -p espeak-ng` -s 120 -vmb/mb-us1"
  $comando_voz_english "Begin"
fi

i=1
acertos=0
while :
do
 echo ""
 echo ""
 echo ""
 resposta=''
 txt_mensagem=''
 #numero=$(shuf -i "$inicio-$fim" -n 1)
 numero=$(shuf -e $(seq $inicio $fim) -n 1)
 nome=$(convert $numero)
 echo "Input the name of number $numero: "
 sleep 1
 if [ "$FALAR" = true ]
 then
  $comando_voz_portuguese "$numero"
 fi
 read resposta
 resposta="${resposta/\-/\ }"
 echo ""
 echo ""
 #echo "$numero: Q: $resposta / R: $nome"
 #$comando_voz_english "               $nome"
 if [ "$resposta" == "$nome" ]
 then
  txt_mensagem="Ok! $resposta"
  ((acertos=acertos+1))
 else
  txt_mensagem="Sorry! You are wrote $resposta but the number is $nome"
 fi
 echo "$txt_mensagem"
 sleep 1
 if [ "$FALAR" = true ]
 then
  $comando_voz_english "$txt_mensagem"
 fi
 echo ""
 echo "Score=$(( acertos*100/i ))% $acertos/$i"
 sleep 2
 ((i=i+1))
 #echo ""
 #echo ""
 #echo "Input [ENTER] to next..."
 #read resposta
done

else
echo "Error! Input $0 [begin number] [end number]. By!"
fi

echo ""

