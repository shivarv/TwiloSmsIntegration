import { LightningElement } from 'lwc';

export default class SentSms extends LightningElement {

    sentTwiloSms(event) {
        console.log('in sentTwiloSms');
    }
}