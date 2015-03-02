defmodule PorterStemmer do
  require IEx
  import String
  def stem(input_word) do
    word = to_string(input_word)
    cond do
      String.length(word) <= 2 -> word
      # does not stem words beginning with an uppercase letter. 
      # This is to prevent stemming of acronyms or names.
      word =~ ~r/^[A-Z]/ -> word
      true ->
        word
          |> step_0
          |> step_1a
          |> step_1b
          |> step_1c
          |> step_2
          |> step_3
          |> step_4
          |> step_5a
          |> step_5b
          |> step_5c
    end
  end

  def step_0(w) do # aka normalize
    word = cond do
      w =~ ~r/^'(.+)'$/ -> String.slice w, 1..-2 # remove single quotes at front & back
      true -> w
    end
    word
    |> String.replace(~r/^'(\w+)/,"\\1")
    |> String.replace(~r/(.+)'$/, "\\1")
    |> String.replace(~r/^y/,"Y")
  end
  

  def step_1a(w) do
    if ( resp = Regex.run( ~r/(\w+)(ss|i)es$/r, w)) do
      [_w, stem, suffix] = resp
      stem <> suffix
    else
      if ( resp = Regex.run( ~r/(\w+)([^s])s$/r, w)) do
        [_w, stem, suffix] = resp
        stem <> suffix
      else
        w
      end
    end
  end

  def step_1b(w) do
    if (resp = Regex.run(~r/(\w+)eed$/r, w)) do
      if List.last(resp) =~ mgr0, do: chop(w), else: w
    else
      if (resp = Regex.run(~r/(\w+)(ed|ing)$/r, w)) do
        [_w, stem, _suffix] = resp
        if stem =~ vowel_in_stem do
          cond do
            stem =~ ~r/(at|bl|iz)$/ -> stem <> "e"
            stem =~ ~r/([^aeiouylsz])\1$/ -> chop(stem)
            stem =~ ~r/^#{consonant_sequence}#{vowels}[^aeiouwxy]$/ -> stem <> "e"
            true -> stem
          end
        else
          w
        end
      else
        w
      end
    end
  end
  
  def step_1c(w) do
    if (resp = Regex.run( ~r/(\w+)y$/, w)) do
      [_w,stem] = resp
      if stem =~ vowel_in_stem, do: stem <> "i", else: w
    else
      w
    end
  end
  def step_2(w) do
    if (resp = suffix_1_regex(w)) do
      [_w, stem, suffix] = resp
      if stem =~ mgr0, do: stem <> step_2_list(suffix), else: w
    else
      w
    end
  end

  def step_3(w) do
    if (resp = Regex.run(~r/(\w+)(icate|ative|alize|iciti|ical|ful|ness)$/r,w)) do
      [_w,stem,suffix] = resp
      if stem =~ mgr0, do: stem <> step_3_list(suffix), else: w
    else
      w
    end 
  end

  def step_4(w) do
    if (resp = suffix_2_regexp(w)) do
      [_w,stem,_suffix] = resp
      if stem =~ mgr1, do: stem, else: w
    else
      if (resp = Regex.run(~r/(\w+)(s|t)(ion)$/r, w)) do
        [_w,stem,suffix|t] =  resp
        if (t = stem <> suffix) =~ mgr1, do: t, else: w
      else
        w
      end
    end
  end

  def step_5a(w) do
    if (resp = Regex.run(~r/(\w+)e$/,w)) do
      [_word,stem] = resp
      if (stem =~ mgr1) || (stem =~ meq1 && not (stem =~ ~r/^#{consonant_sequence}#{vowels}[^aeiouwxy]$/)), do: stem, else: w
    else
      w
    end
  end

  def step_5b(w) do
    if (w =~ ~r/ll$/ && w =~ mgr1), do: chop(w), else: w
  end

  def step_5c(w) do 
    if String.first(w) == "Y", do: "y" <> String.slice(w, 1..-1), else: w
  end

  def chop(s), do: slice(s, 0..-2)
  # V
  def vowels(), do: "[aeiouy]"
  # C
  def consonants(), do: "[^aeiou]"
  # CC
  def consonant_sequence(), do: "#{consonants}(?>[^aeiouy]*)"
  # VV
  def vowel_sequence(), do: "#{vowels}(?>[aeiou]*)"
  def mgr0(), do: ~r/(#{consonant_sequence})?#{vowel_sequence}#{consonant_sequence}/
  def meq1(), do: ~r/^(#{consonant_sequence})?#{vowel_sequence}#{consonant_sequence}(#{vowel_sequence})?$/
  def mgr1(), do: ~r/^(#{consonant_sequence})?#{vowel_sequence}#{consonant_sequence}#{vowel_sequence}#{consonant_sequence}/
  def vowel_in_stem(), do: ~r/^(#{consonant_sequence})?#{vowels}/

  def suffix_1_regex(w) do
    Regex.run ~r/(\w+)(ational|tional|enci|anci|izer|bli|alli|entli|eli|ousli|ization|ation|ator|alism|iveness|fulness|ousness|aliti|iviti|biliti|logi)$/r, w
  end

  def suffix_2_regexp(w) do
    Regex.run ~r/(\w+)(al|ance|ence|er|ic|able|ible|ant|ement|ment|ent|ou|ism|ate|iti|ous|ive|ize)$/r, w
  end
  
  def step_2_list(suffix) do
    case suffix do
      "ational" -> "ate"
      "tional" -> "tion"
      "enci" -> "ence"
      "anci" -> "ance"
      "izer" -> "ize"
      "bli" -> "ble"
      "alli" -> "al"
      "entli" -> "ent"
      "eli" -> "e"
      "ousli" -> "ous"
      "ization" -> "ize"
      "ation" -> "ate"
      "ator" -> "ate"
      "alism" -> "al"
      "iveness" -> "ive"
      "fulness" -> "ful"
      "ousness" -> "ous"
      "aliti" -> "al"
      "iviti" -> "ive"
      "biliti" -> "ble"
      "logi" -> "log"
    end
  end
  

  def step_3_list(suffix) do
    case suffix do
      "tional"  -> "tion"
      "ational" -> "ate"
      "alize"   -> "al"
      "icate"   -> "ic"
      "iciti"   -> "ic"
      "ical"    -> "ic"
      _         -> ""
    end
  end
end