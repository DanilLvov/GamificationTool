class_name MinigameObject

enum QuestionType {
	SINGLECHOICE,
	MULTICHOICE,
	DRAG_AND_DROP,
	ORDER
}
# When adding new question type don't forget to include it into enum and coresponding class into QUESTION_CLASSES
static var QUESTION_CLASSES = {
	QuestionType.SINGLECHOICE: SinglechoiceQuestion,
    QuestionType.MULTICHOICE: MultichoiceQuestion,
    QuestionType.DRAG_AND_DROP: DragAndDropQuestion,
    QuestionType.ORDER: OrderQuestion
}

const default_job = "SOFTWAREENTWICKLUNG"
var _name: String
var _questions_amount: int
var _questions: Array[BaseQuestion]
var _background_image_path: String

func _init(name: String, questions_amount: int, questions: Array[BaseQuestion], background_image_path: String = ""):
    _name = name
    _questions_amount = questions_amount
    _questions = questions 
    _background_image_path = background_image_path 


static func load_minigame_array(path) -> Array[MinigameObject]:
    if not FileAccess.file_exists(path):
        push_error("JSON file not found: %s" % path)
        return []
        
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_error("Cannot open JSON file: %s" % path)
        return []

    var json_text := file.get_as_text()
    var parsed = JSON.parse_string(json_text)

    if parsed == null:
        push_error("Invalid JSON in file: %s" % path)
        return []

    if typeof(parsed) != TYPE_DICTIONARY:
        push_error("Root JSON must be an object/dictionary")
        return []
    
    var array: Array[MinigameObject] = []
    
    for minigame_id in parsed.keys():
        var minigame_data = parsed[minigame_id]
        var name: String
        var questions_amount: int
        var questions: Array[BaseQuestion]
        var background_image_path: String

        if typeof(minigame_data) != TYPE_DICTIONARY:
            push_error("Minigame '%s' must be of Type Dictionary" % minigame_id)
            continue

        if not minigame_data.has("name"):
            push_error("Minigame '%s' has no name" % minigame_id)
            name = "empty"
        else:
            name = minigame_data["name"]

        if not minigame_data.has("questions_amount"):
            push_error("Minigame '%s' has no questions_amount" % minigame_id)
            continue
            # TODO: add function to calculate question amount

        questions_amount = int(minigame_data["questions_amount"])

        if not minigame_data.has("background_image_path"):
            push_error("Minigame '%s' has no background_image_path" % minigame_id)
            background_image_path = ""
        
        else: 
            background_image_path = minigame_data["background_image_path"]

        # Big block where all questions are created
        if not minigame_data.has("questions"):
            push_error("Minigame '%s' has no questions" % minigame_id)
            continue
        elif typeof(minigame_data["questions"]) != TYPE_ARRAY:
            push_error("Minigame '%s' questions must be of Type Arrray" % minigame_id)
            continue

        for question in minigame_data["questions"]:
            var question_text: String
            var question_type
            var job: String
            var extra_content_text: String
            var extra_content_type
            var answers_amount: int
            var solution: Array
            var answers: Array[BaseQuestion.Answer]  

            if typeof(question) != TYPE_DICTIONARY:
                push_error("Question of minigame: '%s' must be of Type Dictionary" % minigame_id)
                continue
            
            if not question.has("question"):
                push_error("Question of minigame '%s' has no question text" % minigame_id)
                continue
            question_text = question["question"]

            if not question.has("question_type"):
                push_error("Question '%s' has no question_type" % question_text)
                continue
            
            question_type = question["question_type"]

            if not QuestionType.has(question_type):
                push_error("Unknown question_type '%s' in minigame '%s'" % [question_type, minigame_id])
                continue
            question_type = QuestionType[question_type]

            if not question.has("job"):
                push_error("Question '%s' has no job, assigning to default job" % question_text)
                job = default_job
            else:
                job = question["job"]

            if question.has("extra_content"):
                var extra_content = question["extra_content"]

                if typeof(extra_content) != TYPE_DICTIONARY:
                    push_error("extra_content of question '%s' must be Dictionary" % question_text)
                    extra_content_text = ""
                    extra_content_type = "NORMAL_QUESTION"
                else:
                    extra_content_text = extra_content.get("text", "")
                    extra_content_type = extra_content.get(
                        "content_type",
                        "NORMAL_QUESTION"
                    )
            else:
                extra_content_text = ""
                extra_content_type = "NORMAL_QUESTION"

            extra_content_type = BaseQuestion.ContentType[extra_content_type]

            if not question.has("answers_amount"):
                push_error("Question '%s' has no answers_amount" % question_text)
                continue

            answers_amount = int(question["answers_amount"])

            if not question.has("solution"):
               push_error("Question '%s' has no solutions" % question_text)
               continue
            elif typeof(question["solution"]) != TYPE_ARRAY:
               push_error("Question '%s' solution must be of type array" % question_text)
               continue
               
            solution = question["solution"]

            if not question.has("answers"):
                push_error("Question '%s' has no answers" % question_text)
                continue

            var answers_data = question["answers"]

            if typeof(answers_data) != TYPE_DICTIONARY:
                push_error("Answers of question '%s' must be Dictionary" % question_text)
                continue

            answers = []

            for answer_id in answers_data.keys():
                var answer_data = answers_data[answer_id]

                if typeof(answer_data) != TYPE_DICTIONARY:
                    push_error("Answer '%s' of question '%s' must be Dictionary" % [answer_id, question_text])
                    continue

                var answer_text: String = answer_data.get("text", "")
                var answer_content_type = answer_data.get(
                    "content_type",
                    BaseQuestion.ContentType.NORMAL_QUESTION
                )

                answer_content_type = BaseQuestion.ContentType[answer_content_type]
                answers.append(
                    BaseQuestion.Answer.new(
                        answer_text,
                        answer_content_type
                    )
                )

            var question_class = QUESTION_CLASSES.get(question_type)
            # Match for different question types
            print("made question for " + minigame_id)
            questions.append(
                question_class.new(
                    question_text,
                    job,
                    answers_amount,
                    solution,
                    answers,
                    extra_content_text,
                    extra_content_type
                )
            )
            

        
        array.append(
            MinigameObject.new(
                name,
                questions_amount, 
                questions, 
                background_image_path, 
            )
        )

    print(array)
    return array


