library(openxlsx)
library(dplyr)

filenames <- c("1-6.xlsx", "7.xlsx", "8.xlsx", "9.xlsx", "10.xlsx", "11.xlsx", "12.xlsx")
trx <- do.call(rbind, lapply(filenames, 
                             read.xlsx, 
                             startRow = 4, 
                             colNames = T, 
                             cols = 2:51,
                             detectDates = T
                             )
               ) %>% tbl_df()

trx_type <- read.xlsx(xlsxFile = "tran_type.xlsx", 
                      startRow = 4, 
                      cols = 3:9
                      ) %>% tbl_df()

acct_type <- read.xlsx(xlsxFile = "acct_type.xlsx", 
                       startRow = 4, 
                       colNames = T, 
                       cols = 3:15) %>% tbl_df()

trx <- inner_join(x = trx, 
                  y = acct_type,
                  by = "ACCT_TYPE") %>%
        inner_join(y = trx_type, 
                   by = "TRAN_TYPE") %>%
        select(CLIENT_NO,
               CLIENT_NAME,
               ACCT_NO, 
               ACCT_TYPE, 
               ACCT_TYPE_DESC, 
               TRAN_DATE, 
               TRAN_TIME, 
               TRAN_TYPE, 
               TRAN_DESC, 
               SODU_TRUOC_GD, 
               PSCO, 
               PSNO, 
               SODU_SAU_GD, 
               CURRENCY, 
               NARRATIVE, 
               ACCT_DOI_UNG, 
               ACCT_DOI_UNG_DESC, 
               REFERENCE, 
               BT_OFFICER_ID, 
               BT_OFFICER_NAME,
               BT_OVERRIDE_ID,
               BT_OVERRIDE_NAME
               )
trx$TRAN_DATE <- as.Date(trx$TRAN_DATE, "%d/%m/%Y")
trx$TRAN_TIME <- strptime(trx$TRAN_TIME, "%d/%m/%Y %H-%M-%S") %>%
                  as.POSIXct()

list.acct <- split(x = trx, f = trx$ACCT_NO)
for (i in 1:length(list.acct))
{
  
}