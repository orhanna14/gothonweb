class ParserError < Exception
end

class Sentence
  #we take the ['direction', 'north'] pairs and convert them to subject, verb, object
  attr_reader :subject, :verb, :number, :object

  def initialize(subject, verb, number, object)
    #The parameters are 2 element arrays, 
    #with the index 0 holding the type of word it is.
    # to get the word, we need index 1
    @subject = subject[1]
    @verb = verb[1]
    @object = object[1]
    @number = number[1]
  end
end

class Parser
  #Takes a word list parameter and returns string or nil
  #If the word list is not empty, 
  #it looks at the first word element and returns the word type
  def self.peek(word_list)
    if word_list
      word = word_list[0]
      return word[0]
    else
      return nil
    end
  end

  #Takes two parameters, word_list and expecting and returns string or nil
  #If the word list is not empty, it removed the first word element and it is 'expecting' type, it returns the word
  def self.match(word_list, expecting)
    if word_list
      word = word_list.shift
      if word[0] == expecting
        return word
      else 
        return nil
      end
    else
      return nil
    end
  end

  def self.parse_number(word_list)
    skip(word_list, 'stop')

    if peek(word_list) == 'number'
      return match(word_list, 'number')
    else
      return ['number', 1]
    end
  end


  #Takes two parameters, word_list and word_type. It peeks at the word list, and pops off the word if it matches the word type. The returned word from the match method is not stored. 
  def self.skip(word_list, word_type)
    while peek(word_list) == word_type
      match(word_list, word_type)
    end
  end

  #Skips 'stop' words. Checks to see if the first word is a verb, if so, remove the word from the element, else raise an error. 
  def self.parse_verb(word_list)
    skip(word_list, 'stop')

    if peek(word_list) == 'verb'
      return match(word_list, 'verb')
    else
      raise ParserError.new("Expected a verb next.")
    end
  end


  #Skips 'stop' words. Checks to see if the second word is a noun or a direction, if so, remove the word from the element, else raise an error. 
  def self.parse_object(word_list)
    skip(word_list, 'stop')
    next_word = peek(word_list)

    if next_word == 'noun'
      return match(word_list, 'noun')
    elsif next_word == 'direction'
      return match(word_list, 'direction')
    else
      raise ParserError.new("Expected a noun or a direction next.")
    end
  end

  #Skips 'stop' words. Checks to see if the 2nd or 3rd word is a noun or verb. If it is a noun, remove the word from the element, and if it is a verb, set the default noun to player. Else raise an error. 
  def self.parse_subject(word_list)
    skip(word_list, 'stop')
    next_word = peek(word_list)

    if next_word == 'noun'
      return match(word_list, 'noun')
    elsif next_word == 'verb'
      return ['noun', 'player']
    else
      raise ParserError.new("Expected a verb next.")
    end
  end

  #Parses the sentence with the sentence structure of S + V + O
  def self.parse_sentence(word_list)
    subject = parse_subject(word_list)
    verb = parse_verb(word_list)
    number = parse_number(word_list)
    object = parse_object(word_list)

    return Sentence.new(subject, verb, number, object)
  end
end