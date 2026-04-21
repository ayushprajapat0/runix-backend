import { subitProblemService } from "./submission.service.js";

export const submitProblem = async (req, res) => {
    try {
        if (!req.user || !req.user.id) {
            return res.status(401).json({ message: "Please Login to submit or run the problem" });
        }
        const result = await subitProblemService(req, res);
        if (result.error) {
            return res.status(500).json({ message: result.error });
        }
        if (result) {
            return res.status(200).json({ message: "Problem submitted successfully", result });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
}