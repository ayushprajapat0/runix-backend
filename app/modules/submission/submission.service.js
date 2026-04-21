export const subitProblemService = async (req, res) => {
    try {
        const Userid = req.user.id;
        const { problemId, languageId, code } = req.body;
        if (!problemId || !languageId || !code) {
            return res.status(400).json({ message: "Please provide all the required fields" });
        }
        const query = `INSERT INTO submissions (user_id, problem_id, language_id, code) VALUES ($1, $2, $3, $4)`;
        const values = [Userid, problemId, languageId, code];
        return result.rows[0];
    } catch (error) {
        console.log(error);
        return error;
    }
}