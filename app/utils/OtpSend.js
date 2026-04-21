import nodemailer from 'nodemailer';

export const sendOtp = async (email, otp) => {
    try {
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.GMAIL_USER,
                pass: process.env.GMAIL_PASSWORD
            }
        })
        const mailOptions = {
            from: `"Runix" <${process.env.GMAIL_USER}>`,
            to: email,
            subject: 'Your Runix Verification Code',
            text: `Your Runix OTP is: ${otp}\n\nThis OTP is valid for 10 minutes. Do not share it with anyone.`,
        }
        await transporter.sendMail(mailOptions);
        console.log('OTP sent successfully');
        return true;
    } catch (error) {
        console.error('Error sending OTP:', error);
        throw error; // let the controller catch & handle it
    }
}