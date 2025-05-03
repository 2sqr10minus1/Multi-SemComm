from openai import OpenAI

client = OpenAI(api_key="sk-789032cd049b4b6b84431f6fdc504416", base_url="https://api.deepseek.com")

# 这个agent加上了一个分词器，输出字数+压缩后的语句
def count_chars(text):
    chinese = 0
    english = 0
    for char in text:
        if '\u4e00' <= char <= '\u9fff':  # 中文字符的Unicode
            chinese += 1
        elif char.isalpha():  # 英字母
            english += 1
    return chinese, english

# 压缩文本
messages = [
    {
        "role": "system",
        "content": """
            You are a text compression assistant. Your task is to take any input text and compress it into shorter text while retaining the essential information. 
            Avoid unnecessary words and keep the output concise. Do not provide any explanations or additional information beyond the compressed text.
            
            Example:
            Input: "The quick brown fox jumps over the lazy dog."
            Output: "The fox jumps over the lazy dog."
            
            Another Example:
            Input: "In the middle of difficulty lies opportunity."
            Output: "Opportunity lies in difficulty."
            
            Remember to always respond with the compressed version of the input text.
        """
    }
]

while True:
    user_input = input("You: ")
    if user_input.lower() in ['quit', 'exit']:
        print("Conversation ended.")
        break
    
    # 计算中文字符/英文字母个数
    chinese, english = count_chars(user_input)
    total = chinese + english
    
    # 把后续问答补充到prompt
    messages.append({"role": "user", "content": user_input})
    
    # 收集回复
    try:
        response = client.chat.completions.create(
            model="deepseek-reasoner",
            messages=messages
        )
        assistant_response = response.choices[0].message.content
        # 在回复开始打印出字符个数
        print(f"{total}{assistant_response}")
        
        # 增加模型输出，并且一并输出
        messages.append({"role": "assistant", "content": assistant_response})
    
    except Exception as e:
        print(f"An error occurred: {e}")
        continue